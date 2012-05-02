// Copyright (c) 2009 INRIA Sophia-Antipolis (France).
// All rights reserved.
//
// This file is part of CGAL (www.cgal.org).
// You can redistribute it and/or modify it under the terms of the GNU
// General Public License as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// Licensees holding a valid commercial license may use this file in
// accordance with the commercial license agreement provided with the software.
//
// This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
// WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//
// $URL$
// $Id$
//
//
// Author(s)     : Laurent Rineau, Stephane Tayeb
//
//******************************************************************************
// File Description :
// Implements a mesher_3 with two mesher levels : one for facets and one for
// tets.
//******************************************************************************

#ifndef CGAL_MESH_3_MESHER_3_H
#define CGAL_MESH_3_MESHER_3_H

#include<CGAL/Mesh_3/Refine_facets_3.h>
#include<CGAL/Mesh_3/Refine_cells_3.h>
#include <CGAL/Mesh_3/Refine_tets_visitor.h>
#include <CGAL/Mesher_level_visitors.h>

#ifdef CGAL_MESH_3_USE_OLD_SURFACE_RESTRICTED_DELAUNAY_UPDATE
#include <CGAL/Surface_mesher/Surface_mesher_visitor.h>
#endif

#ifdef CONCURRENT_MESH_3
# include <CGAL/Mesh_3/Concurrent_mesher_config.h>
# include <tbb/compat/thread>
#endif

#include <CGAL/Timer.h>

#ifdef MESH_3_PROFILING
  #include <CGAL/Mesh_3/Profiling_tools.h>
#endif

#include <boost/format.hpp>
#include <string>

namespace CGAL {
  
namespace Mesh_3 {
    
    
// Class Mesher_3
//
template<class C3T3, class MeshCriteria, class MeshDomain>
class Mesher_3
{
public:
  // Self
  typedef Mesher_3<C3T3, MeshCriteria, MeshDomain> Self;
  
  typedef typename C3T3::Triangulation Triangulation;
  
  //-------------------------------------------------------
  // Mesher_levels
  //-------------------------------------------------------
  /// Facets mesher level
  typedef Mesh_3::Refine_facets_3<
      Triangulation,
      typename MeshCriteria::Facet_criteria,
      MeshDomain,
      C3T3,
      Null_mesher_level>                            Facets_level;
  
  /// Cells mesher level
  typedef Mesh_3::Refine_cells_3<
      Triangulation,
      typename MeshCriteria::Cell_criteria,
      MeshDomain,
      C3T3,
      Facets_level>                                 Cells_level;
  
  //-------------------------------------------------------
  // Visitors
  //-------------------------------------------------------
  /// Facets visitor : to update cells when refining surface
  typedef tets::Refine_facets_visitor<
      Triangulation,
      Cells_level,
      Null_mesh_visitor>                            Facets_visitor;
  
#ifndef CGAL_MESH_3_USE_OLD_SURFACE_RESTRICTED_DELAUNAY_UPDATE
  /// Cells visitor : it just need to know previous level
  typedef Null_mesh_visitor_level<Facets_visitor>   Cells_visitor;
#else
  /// Cells visitor : to update surface (restore restricted Delaunay)
  /// when refining cells
  typedef Surface_mesher::Visitor<
      Triangulation,
      Facets_level,
      Facets_visitor>                               Cells_visitor;
#endif

  /// Constructor
  Mesher_3(C3T3&               c3t3,
           const MeshDomain&   domain,
           const MeshCriteria& criteria);
  
  /// Destructor
  ~Mesher_3() { }
  
  /// Launch mesh refinement
  double refine_mesh();

  /// Debug
  std::string debug_info() const;
  std::string debug_info_header() const;
  
  // Step-by-step methods
  void initialize();
  void fix_c3t3();
  void display_number_of_bad_elements();
  void one_step();
  bool is_algorithm_done();
  
#ifdef CGAL_MESH_3_MESHER_STATUS_ACTIVATED
  struct Mesher_status
  { 
    std::size_t vertices, facet_queue, cells_queue;
    
    Mesher_status(std::size_t v, std::size_t f, std::size_t c)
     : vertices(v), facet_queue(f), cells_queue(c) {}
  };
  
  Mesher_status status() const;
#endif
  
private:
  void remove_cells_from_c3t3();
  
private:
  /// Lock data structure
#ifdef CONCURRENT_MESH_3
  LockDataStructureType m_lock_ds;
  WorksharingDataStructureType m_worksharing_ds;
#endif

  /// Meshers
  Null_mesher_level null_mesher_;
  Facets_level facets_mesher_; 
  Cells_level cells_mesher_;
  
  /// Visitors
  Null_mesh_visitor null_visitor_;
  Facets_visitor facets_visitor_;
  Cells_visitor cells_visitor_;
  
  /// The container of the resulting mesh
  C3T3& r_c3t3_;
  
private:
  // Disabled copy constructor
  Mesher_3(const Self& src);
  // Disabled assignment operator
  Self& operator=(const Self& src);
  
};  // end class Mesher_3
    
    
    
template<class C3T3, class MC, class MD>
Mesher_3<C3T3,MC,MD>::Mesher_3(C3T3& c3t3,
                               const MD& domain,
                               const MC& criteria)
:
#ifdef CGAL_MESH_3_CONCURRENT_REFINEMENT
m_lock_ds(c3t3.bbox(), // CJTODO: this is the bbox of the first N points => enlarge it?
          Concurrent_mesher_config::get().locking_grid_num_cells_per_axis),
m_worksharing_ds(c3t3.bbox()), // CJTODO: this is the bbox of the first N points => enlarge it?
#endif
null_mesher_()
, facets_mesher_(c3t3.triangulation(),
                 criteria.facet_criteria_object(),
                 domain,
                 null_mesher_,
                 c3t3
#ifdef CGAL_MESH_3_CONCURRENT_REFINEMENT
                 , &m_lock_ds
                 , &m_worksharing_ds
#endif
                 )
, cells_mesher_(c3t3.triangulation(),
                criteria.cell_criteria_object(),
                domain,
                facets_mesher_,
                c3t3
#ifdef CGAL_MESH_3_CONCURRENT_REFINEMENT
                 , &m_lock_ds
                 , &m_worksharing_ds
#endif
                 )
, null_visitor_()
, facets_visitor_(&cells_mesher_, &null_visitor_)
#ifndef CGAL_MESH_3_USE_OLD_SURFACE_RESTRICTED_DELAUNAY_UPDATE
, cells_visitor_(facets_visitor_)
#else
, cells_visitor_(&facets_mesher_, &facets_visitor_)
#endif
, r_c3t3_(c3t3)
{
}



template<class C3T3, class MC, class MD>
double
Mesher_3<C3T3,MC,MD>::refine_mesh()
{
  CGAL::Timer timer;
  timer.start();
  double elapsed_time = 0.;
  
  // First surface mesh could modify c3t3 without notifying cells_mesher
  // So we have to ensure that no old cell will be left in c3t3
  remove_cells_from_c3t3();
  
#ifndef CGAL_MESH_3_VERBOSE
  // Scan surface and refine it
  initialize();
#ifdef MESH_3_PROFILING
  std::cerr << "Refining facets...";
  WallClockTimer t;
#endif
  facets_mesher_.refine(facets_visitor_);
#ifdef MESH_3_PROFILING
  double facet_ref_time = t.elapsed();
  std::cerr << "done in " << facet_ref_time << " seconds." << std::endl;
# ifdef CGAL_MESH_3_EXPORT_PERFORMANCE_DATA
  CGAL_MESH_3_SET_PERFORMANCE_DATA("Facets_time", facet_ref_time);
# endif
#endif

  // Then activate facet to surface visitor (surface could be
  // refined again if it is encroached)
  facets_visitor_.activate();

  // Then scan volume and refine it
  cells_mesher_.scan_triangulation();
#ifdef MESH_3_PROFILING
  std::cerr << "Refining cells...";
  t.reset();
#endif
  cells_mesher_.refine(cells_visitor_);
#ifdef MESH_3_PROFILING
  double cell_ref_time = t.elapsed();
  std::cerr << "done in " << cell_ref_time << " seconds." << std::endl;
# ifdef CGAL_MESH_3_EXPORT_PERFORMANCE_DATA
  CGAL_MESH_3_SET_PERFORMANCE_DATA("Cells_refin_time", cell_ref_time);
# endif
#endif

#else // ifdef CGAL_MESH_3_VERBOSE
  std::cerr << "Start surface scan...";
  initialize();
  std::cerr << "end scan. [Bad facets:" << facets_mesher_.size() << "]";
  std::cerr << std::endl << std::endl;
  elapsed_time += timer.time();
  timer.stop(); timer.reset(); timer.start();
  
  const Triangulation& r_tr = r_c3t3_.triangulation();
  int nbsteps = 0;
  
  std::cerr << "Refining Surface...\n";
  std::cerr << "Legende of the following line: "
            << "(#vertices,#steps," << cells_mesher_.debug_info_header()
            << ")\n";
  
  std::cerr << "(" << r_tr.number_of_vertices() << ","
            << nbsteps << "," << cells_mesher_.debug_info() << ")";
  
  while ( ! facets_mesher_.is_algorithm_done() )
  {
    facets_mesher_.one_step(facets_visitor_);
    std::cerr
    << boost::format("\r             \r"
                     "(%1%,%2%,%3%) (%|4$.1f| vertices/s)")
    % r_tr.number_of_vertices()
    % nbsteps % cells_mesher_.debug_info()
    % (nbsteps / timer.time());
    ++nbsteps;
  }
  std::cerr << std::endl;
  std::cerr << "Total refining surface time: " << timer.time() << "s" << std::endl;
  std::cerr << std::endl;

  elapsed_time += timer.time();
  timer.stop(); timer.reset(); timer.start();
  nbsteps = 0;
  
  facets_visitor_.activate();
  std::cerr << "Start volume scan...";
  cells_mesher_.scan_triangulation();
  std::cerr << "end scan. [Bad tets:" << cells_mesher_.size() << "]";
  std::cerr << std::endl << std::endl;
  elapsed_time += timer.time();
  timer.stop(); timer.reset(); timer.start();
  
  std::cerr << "Refining...\n";
  std::cerr << "Legende of the following line: "
            << "(#vertices,#steps," << cells_mesher_.debug_info_header()
            << ")\n";
  std::cerr << "(" << r_tr.number_of_vertices() << ","
            << nbsteps << "," << cells_mesher_.debug_info() << ")";

  while ( ! cells_mesher_.is_algorithm_done() )
  {
    cells_mesher_.one_step(cells_visitor_);
    std::cerr
        << boost::format("\r             \r"
                     "(%1%,%2%,%3%) (%|4$.1f| vertices/s)")
        % r_tr.number_of_vertices()
        % nbsteps % cells_mesher_.debug_info()
        % (nbsteps / timer.time());
    ++nbsteps;
  }
  std::cerr << std::endl;

  std::cerr << "Total refining volume time: " << timer.time() << "s" << std::endl;
  std::cerr << "Total refining time: " << timer.time()+elapsed_time << "s" << std::endl;
  std::cerr << std::endl;
#endif
  
  timer.stop();
  elapsed_time += timer.time();
  
#ifdef CHECK_AND_DISPLAY_THE_NUMBER_OF_BAD_ELEMENTS_IN_THE_END
  display_number_of_bad_elements();
#endif

  return elapsed_time;
}


template<class C3T3, class MC, class MD>
void
Mesher_3<C3T3,MC,MD>::
initialize()
{
#ifdef CONCURRENT_MESH_3
  Concurrent_mesher_config::load_config_file(CONFIG_FILENAME, false);
#endif

#ifdef CGAL_MESH_3_CONCURRENT_REFINEMENT
  // we're not multi-thread, yet
  r_c3t3_.triangulation().set_lock_data_structure(0);
#endif

  facets_mesher_.scan_triangulation();
#ifdef CGAL_MESH_3_CONCURRENT_REFINEMENT

# ifdef CGAL_CONCURRENT_MESH_3_VERBOSE
  std::cerr << "A little bit of sequential refinement... ";
# endif

  // Start by a little bit of refinement to get a coarse mesh
  // => Good approx of bounding box
  // => The coarse mesh can be used for a data-dependent space partitionning
  const int NUM_VERTICES_OF_COARSE_MESH = static_cast<int>(
    std::thread::hardware_concurrency()
    *Concurrent_mesher_config::get().num_vertices_of_coarse_mesh_per_core);
  facets_mesher_.refine_sequentially_up_to_N_vertices(
    facets_visitor_, NUM_VERTICES_OF_COARSE_MESH);
  // Set new bounding boxes
  const Bbox_3 &bbox = r_c3t3_.bbox();
  m_lock_ds.set_bbox(bbox);
  m_worksharing_ds.set_bbox(bbox);
  
# ifdef CGAL_CONCURRENT_MESH_3_VERBOSE
  std::cerr << "done." << std::endl;
  std::cerr
    << "Vertices: " << r_c3t3_.triangulation().number_of_vertices() << std::endl
    << "Facets  : " << r_c3t3_.triangulation().number_of_facets() << std::endl
    << "Tets    : " << r_c3t3_.triangulation().number_of_cells() << std::endl;
# endif
  
# ifdef CGAL_MESH_3_ADD_OUTSIDE_POINTS_ON_A_FAR_SPHERE

#   ifdef CGAL_CONCURRENT_MESH_3_VERBOSE
  std::cerr << "Adding points on a far sphere... ";
#   endif

  // Compute radius for far sphere
  const double& xdelta = bbox.xmax()-bbox.xmin();
  const double& ydelta = bbox.ymax()-bbox.ymin();
  const double& zdelta = bbox.zmax()-bbox.zmin();
  const double radius = std::sqrt(xdelta*xdelta +
                                ydelta*ydelta +
                                zdelta*zdelta) / 2;
  Random_points_on_sphere_3<Point> random_point(radius*1.1);
  const int NUM_PSEUDO_INFINITE_VERTICES = static_cast<int>(
    std::thread::hardware_concurrency()
    *Concurrent_mesher_config::get().num_pseudo_infinite_vertices_per_core);
  for (int i = 0 ; i < NUM_PSEUDO_INFINITE_VERTICES ; ++i, ++random_point)
    r_c3t3_.triangulation().insert(*random_point);

#   ifdef CGAL_CONCURRENT_MESH_3_VERBOSE
  std::cerr << "done." << std::endl;
#   endif

# endif // CGAL_MESH_3_ADD_OUTSIDE_POINTS_ON_A_FAR_SPHERE
  
  // From now on, we're multi-thread
  r_c3t3_.triangulation().set_lock_data_structure(&m_lock_ds);
#endif
}


template<class C3T3, class MC, class MD>
void
Mesher_3<C3T3,MC,MD>::
fix_c3t3()
{
  if ( ! facets_visitor_.is_active() )
  {
    cells_mesher_.scan_triangulation();    
  }
}


template<class C3T3, class MC, class MD>
void
Mesher_3<C3T3,MC,MD>::
display_number_of_bad_elements()
{
  int nf = facets_mesher_.get_number_of_bad_elements();
  int nc = cells_mesher_.get_number_of_bad_elements();
  std::cerr << "Bad facets: " << nf << " - Bad cells: " << nc << std::endl;
}

template<class C3T3, class MC, class MD>
void
Mesher_3<C3T3,MC,MD>::
one_step()
{
  if ( ! facets_visitor_.is_active() )
  {
    facets_mesher_.one_step(facets_visitor_);
    
    if ( facets_mesher_.is_algorithm_done() )
    {
      facets_visitor_.activate();
      cells_mesher_.scan_triangulation();
    }
  }
  else
  {
    cells_mesher_.one_step(cells_visitor_);    
  }
}
  
template<class C3T3, class MC, class MD>
bool
Mesher_3<C3T3,MC,MD>::
is_algorithm_done()
{
  return cells_mesher_.is_algorithm_done();
}


#ifdef CGAL_MESH_3_MESHER_STATUS_ACTIVATED
template<class C3T3, class MC, class MD>
typename Mesher_3<C3T3,MC,MD>::Mesher_status
Mesher_3<C3T3,MC,MD>::
status() const
{
  return Mesher_status(r_c3t3_.triangulation().number_of_vertices(),
                       facets_mesher_.queue_size(),
                       cells_mesher_.queue_size());
}  
#endif


template<class C3T3, class MC, class MD>
void
Mesher_3<C3T3,MC,MD>::
remove_cells_from_c3t3()
{
  for ( typename C3T3::Triangulation::Finite_cells_iterator 
    cit = r_c3t3_.triangulation().finite_cells_begin(),
    end = r_c3t3_.triangulation().finite_cells_end() ; cit != end ; ++cit )
  {
    r_c3t3_.remove_from_complex(cit);
  }
}

template<class C3T3, class MC, class MD>
inline
std::string 
Mesher_3<C3T3,MC,MD>::debug_info() const
{
  return cells_mesher_.debug_info();
}
    
template<class C3T3, class MC, class MD>
inline
std::string 
Mesher_3<C3T3,MC,MD>::debug_info_header() const
{
  return cells_mesher_.debug_info_header();
}

}  // end namespace Mesh_3
  
}  // end namespace CGAL


#endif // CGAL_MESH_3_MESHER_3_H
