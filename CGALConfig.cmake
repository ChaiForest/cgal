#
# This files contains definitions needed to use CGAL in a program.
# DO NOT EDIT THIS. The definitons have been generated by CMake at configuration time.
# This file is loaded by cmake via the command "find_package(CGAL)"
#
# This file correspond to a possibly out-of-sources CGAL configuration, thus the actual location
# must be given by the cmake variable or enviroment variable CGAL_DIR.

set(CGAL_CONFIG_LOADED TRUE)

get_filename_component(CGAL_CONFIG_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)

set(CGAL_HEADER_ONLY "FALSE" )

# The code for including exported targets is different from
# CGAL_Config_install.cmake. We do not have separate export files in
# an installed version and we need to make sure that we are not
# currently building CGAL.
if(NOT CGAL_BUILDING_LIBS)
  include("${CGAL_CONFIG_DIR}/CGALExports.cmake")
else()
  # We are currently in a CGAL Build and CGALExports.cmake has not
  # necessarily been created yet. Just alias the targets. Also don't
  # access the LOCATION property here to set lib_LIBRARY, since those
  # targets are not imported and this is disallowed by CMP0026. Just
  # set it to the target name.
  macro(CGAL_alias_library lib)
    if(TARGET ${lib} AND NOT TARGET CGAL::${lib})
      add_library(CGAL::${lib} ALIAS ${lib})
    endif()
  endmacro()

  CGAL_alias_library(CGAL)
  CGAL_alias_library(CGAL_Core)
  CGAL_alias_library(CGAL_ImageIO)
  CGAL_alias_library(CGAL_Qt5)
endif()

macro(CGAL_set_LIB_LIBRARY_var lib)
  if(TARGET CGAL::${lib})
    set(${lib}_LIBRARY CGAL::${lib})
  else()
    set(${lib}_LIBRARY "")
  endif()
endmacro()

CGAL_set_LIB_LIBRARY_var(CGAL)
CGAL_set_LIB_LIBRARY_var(CGAL_Core)
CGAL_set_LIB_LIBRARY_var(CGAL_ImageIO)
CGAL_set_LIB_LIBRARY_var(CGAL_Qt5)

set(CGAL_CONFIGURED_LIBRARIES "CGAL;CGAL_Core;CGAL_ImageIO;CGAL_Qt5")

# Check for possible config files of our libraries and include them.
foreach(lib ${CGAL_CONFIGURED_LIBRARIES})
  include("${CGAL_CONFIG_DIR}/${lib}LibConfig.cmake" OPTIONAL)
endforeach()

set(CGAL_INSTALLATION_PACKAGE_DIR "/home/gimeno/CGAL/Installation")
set(CGAL_CORE_PACKAGE_DIR "/home/gimeno/CGAL/Core")
set(CGAL_GRAPHICSVIEW_PACKAGE_DIR "/home/gimeno/CGAL/GraphicsView")

set(CGAL_MAJOR_VERSION    "4" )
set(CGAL_MINOR_VERSION    "13" )
set(CGAL_BUGFIX_VERSION   "0" )
set(CGAL_BUILD_VERSION    "900" )
set(CGAL_SCM_BRANCH_NAME  "Demo-Add_transparency-GF")
set(CGAL_GIT_SHA1         "")

set(CGAL_BUILD_SHARED_LIBS        "ON" )
set(CGAL_Boost_USE_STATIC_LIBS    "OFF" )

set(CGAL_CXX_FLAGS_INIT                   "" )
set(CGAL_CXX_FLAGS_RELEASE_INIT           "-O3 -DNDEBUG" )
set(CGAL_CXX_FLAGS_DEBUG_INIT             "-g" )
set(CGAL_MODULE_LINKER_FLAGS_INIT         "" )
set(CGAL_MODULE_LINKER_FLAGS_RELEASE_INIT "" )
set(CGAL_MODULE_LINKER_FLAGS_DEBUG_INIT   "" )
set(CGAL_SHARED_LINKER_FLAGS_INIT         "" )
set(CGAL_SHARED_LINKER_FLAGS_RELEASE_INIT "" )
set(CGAL_SHARED_LINKER_FLAGS_DEBUG_INIT   "" )
set(CGAL_BUILD_TYPE_INIT                  "" )

set(CGAL_INCLUDE_DIRS      "/home/gimeno/CGAL/include;/home/gimeno/CGAL/AABB_tree/include;/home/gimeno/CGAL/Advancing_front_surface_reconstruction/include;/home/gimeno/CGAL/Algebraic_foundations/include;/home/gimeno/CGAL/Algebraic_kernel_d/include;/home/gimeno/CGAL/Algebraic_kernel_for_circles/include;/home/gimeno/CGAL/Algebraic_kernel_for_spheres/include;/home/gimeno/CGAL/Alpha_shapes_2/include;/home/gimeno/CGAL/Alpha_shapes_3/include;/home/gimeno/CGAL/Apollonius_graph_2/include;/home/gimeno/CGAL/Arithmetic_kernel/include;/home/gimeno/CGAL/Arrangement_on_surface_2/include;/home/gimeno/CGAL/BGL/include;/home/gimeno/CGAL/Barycentric_coordinates_2/include;/home/gimeno/CGAL/Boolean_set_operations_2/include;/home/gimeno/CGAL/Bounding_volumes/include;/home/gimeno/CGAL/Box_intersection_d/include;/home/gimeno/CGAL/CGAL_Core/include;/home/gimeno/CGAL/CGAL_ImageIO/include;/home/gimeno/CGAL/CGAL_ipelets/include;/home/gimeno/CGAL/Cartesian_kernel/include;/home/gimeno/CGAL/Circular_kernel_2/include;/home/gimeno/CGAL/Circular_kernel_3/include;/home/gimeno/CGAL/Circulator/include;/home/gimeno/CGAL/Classification/include;/home/gimeno/CGAL/Combinatorial_map/include;/home/gimeno/CGAL/Cone_spanners_2/include;/home/gimeno/CGAL/Convex_decomposition_3/include;/home/gimeno/CGAL/Convex_hull_2/include;/home/gimeno/CGAL/Convex_hull_3/include;/home/gimeno/CGAL/Convex_hull_d/include;/home/gimeno/CGAL/Distance_2/include;/home/gimeno/CGAL/Distance_3/include;/home/gimeno/CGAL/Envelope_2/include;/home/gimeno/CGAL/Envelope_3/include;/home/gimeno/CGAL/Filtered_kernel/include;/home/gimeno/CGAL/Generalized_map/include;/home/gimeno/CGAL/Generator/include;/home/gimeno/CGAL/Geomview/include;/home/gimeno/CGAL/GraphicsView/include;/home/gimeno/CGAL/HalfedgeDS/include;/home/gimeno/CGAL/Hash_map/include;/home/gimeno/CGAL/Homogeneous_kernel/include;/home/gimeno/CGAL/Inscribed_areas/include;/home/gimeno/CGAL/Installation/include;/home/gimeno/CGAL/Interpolation/include;/home/gimeno/CGAL/Intersections_2/include;/home/gimeno/CGAL/Intersections_3/include;/home/gimeno/CGAL/Interval_skip_list/include;/home/gimeno/CGAL/Interval_support/include;/home/gimeno/CGAL/Inventor/include;/home/gimeno/CGAL/Jet_fitting_3/include;/home/gimeno/CGAL/Kernel_23/include;/home/gimeno/CGAL/Kernel_d/include;/home/gimeno/CGAL/LEDA/include;/home/gimeno/CGAL/Linear_cell_complex/include;/home/gimeno/CGAL/Matrix_search/include;/home/gimeno/CGAL/Mesh_2/include;/home/gimeno/CGAL/Mesh_3/include;/home/gimeno/CGAL/Mesher_level/include;/home/gimeno/CGAL/Minkowski_sum_2/include;/home/gimeno/CGAL/Minkowski_sum_3/include;/home/gimeno/CGAL/Modifier/include;/home/gimeno/CGAL/Modular_arithmetic/include;/home/gimeno/CGAL/Nef_2/include;/home/gimeno/CGAL/Nef_3/include;/home/gimeno/CGAL/Nef_S2/include;/home/gimeno/CGAL/NewKernel_d/include;/home/gimeno/CGAL/Number_types/include;/home/gimeno/CGAL/OpenNL/include;/home/gimeno/CGAL/Operations_on_polyhedra/include;/home/gimeno/CGAL/Optimal_transportation_reconstruction_2/include;/home/gimeno/CGAL/Optimisation_basic/include;/home/gimeno/CGAL/Partition_2/include;/home/gimeno/CGAL/Periodic_2_triangulation_2/include;/home/gimeno/CGAL/Periodic_3_triangulation_3/include;/home/gimeno/CGAL/Point_set_2/include;/home/gimeno/CGAL/Point_set_3/include;/home/gimeno/CGAL/Point_set_processing_3/include;/home/gimeno/CGAL/Point_set_shape_detection_3/include;/home/gimeno/CGAL/Poisson_surface_reconstruction_3/include;/home/gimeno/CGAL/Polygon/include;/home/gimeno/CGAL/Polygon_mesh_processing/include;/home/gimeno/CGAL/Polyhedron/include;/home/gimeno/CGAL/Polyhedron_IO/include;/home/gimeno/CGAL/Polyline_simplification_2/include;/home/gimeno/CGAL/Polynomial/include;/home/gimeno/CGAL/Polytope_distance_d/include;/home/gimeno/CGAL/Principal_component_analysis/include;/home/gimeno/CGAL/Principal_component_analysis_LGPL/include;/home/gimeno/CGAL/Profiling_tools/include;/home/gimeno/CGAL/Property_map/include;/home/gimeno/CGAL/QP_solver/include;/home/gimeno/CGAL/Random_numbers/include;/home/gimeno/CGAL/Ridges_3/include;/home/gimeno/CGAL/STL_Extension/include;/home/gimeno/CGAL/Scale_space_reconstruction_3/include;/home/gimeno/CGAL/SearchStructures/include;/home/gimeno/CGAL/Segment_Delaunay_graph_2/include;/home/gimeno/CGAL/Segment_Delaunay_graph_Linf_2/include;/home/gimeno/CGAL/Set_movable_separability_2/include;/home/gimeno/CGAL/Skin_surface_3/include;/home/gimeno/CGAL/Snap_rounding_2/include;/home/gimeno/CGAL/Solver_interface/include;/home/gimeno/CGAL/Spatial_searching/include;/home/gimeno/CGAL/Spatial_sorting/include;/home/gimeno/CGAL/Straight_skeleton_2/include;/home/gimeno/CGAL/Stream_lines_2/include;/home/gimeno/CGAL/Stream_support/include;/home/gimeno/CGAL/Subdivision_method_3/include;/home/gimeno/CGAL/Surface_mesh/include;/home/gimeno/CGAL/Surface_mesh_deformation/include;/home/gimeno/CGAL/Surface_mesh_parameterization/include;/home/gimeno/CGAL/Surface_mesh_segmentation/include;/home/gimeno/CGAL/Surface_mesh_shortest_path/include;/home/gimeno/CGAL/Surface_mesh_simplification/include;/home/gimeno/CGAL/Surface_mesh_skeletonization/include;/home/gimeno/CGAL/Surface_mesher/include;/home/gimeno/CGAL/Surface_sweep_2/include;/home/gimeno/CGAL/TDS_2/include;/home/gimeno/CGAL/TDS_3/include;/home/gimeno/CGAL/Testsuite/include;/home/gimeno/CGAL/Three/include;/home/gimeno/CGAL/Triangulation/include;/home/gimeno/CGAL/Triangulation_2/include;/home/gimeno/CGAL/Triangulation_3/include;/home/gimeno/CGAL/Union_find/include;/home/gimeno/CGAL/Visibility_2/include;/home/gimeno/CGAL/Voronoi_diagram_2/include" )
set(CGAL_MODULES_DIR       "/home/gimeno/CGAL/Installation/cmake/modules" )
set(CGAL_LIBRARIES_DIR     "/home/gimeno/CGAL/lib" )

# If CGAL_ImageIO is built, tell if it was linked with Zlib.
set(CGAL_ImageIO_USE_ZLIB                 "ON" )

set(CGAL_VERSION "${CGAL_MAJOR_VERSION}.${CGAL_MINOR_VERSION}.${CGAL_BUGFIX_VERSION}")

set(CGAL_USE_FILE "${CGAL_MODULES_DIR}/UseCGAL.cmake" )

if ( CGAL_FIND_REQUIRED )
  set( CHECK_CGAL_COMPONENT_MSG_ON_ERROR TRUE        )
  set( CHECK_CGAL_COMPONENT_ERROR_TYPE   FATAL_ERROR )
  set( CHECK_CGAL_COMPONENT_ERROR_TITLE  "ERROR:"    )
else()
  if ( NOT CGAL_FIND_QUIETLY )
    set( CHECK_CGAL_COMPONENT_MSG_ON_ERROR TRUE      )
    set( CHECK_CGAL_COMPONENT_ERROR_TYPE   STATUS    )
    set( CHECK_CGAL_COMPONENT_ERROR_TITLE "NOTICE:" )
  else()
    set( CHECK_CGAL_COMPONENT_MSG_ON_ERROR FALSE )
  endif()
endif()

macro(check_cgal_component COMPONENT)

  set( CGAL_LIB ${COMPONENT} )
  #message("LIB: ${CGAL_LIB}")

  if ( "${CGAL_LIB}" STREQUAL "CGAL" )
    set( CGAL_FOUND TRUE )
    set( CHECK_CGAL_ERROR_TAIL "" )
    get_property(CGAL_CGAL_is_imported TARGET CGAL::CGAL PROPERTY IMPORTED)
    if(CGAL_CGAL_is_imported)
      include("${CGAL_MODULES_DIR}/CGAL_SetupBoost.cmake")
      get_property(CGAL_requires_Boost_libs
        GLOBAL PROPERTY CGAL_requires_Boost_Thread)
      if(CGAL_requires_Boost_libs AND TARGET Boost::thread)
        set_property(TARGET CGAL::CGAL APPEND PROPERTY INTERFACE_LINK_LIBRARIES Boost::thread)
      endif()
    endif()
  else( "${CGAL_LIB}" STREQUAL "CGAL" )
    if ( WITH_${CGAL_LIB} )
      if(TARGET CGAL::${CGAL_LIB})
        if ("${CGAL_LIB}" STREQUAL "CGAL_Qt5")
          
          include("${CGAL_MODULES_DIR}/CGAL_SetupCGAL_Qt5Dependencies.cmake")

          if(CGAL_Qt5_MISSING_DEPS)
            set( CGAL_Qt5_FOUND FALSE )
            message(STATUS "libCGAL_Qt5 is missing the dependencies: ${CGAL_Qt5_MISSING_DEPS} cannot be configured.")
          else()
            set( CGAL_Qt5_FOUND TRUE )
          endif()
        else("${CGAL_LIB}" STREQUAL "CGAL_Qt5")
          # Librairies that have no dependencies
          set( ${CGAL_LIB}_FOUND TRUE )
        endif("${CGAL_LIB}" STREQUAL "CGAL_Qt5")
      else(TARGET CGAL::${CGAL_LIB})
        set( ${CGAL_LIB}_FOUND FALSE )
        set( CHECK_${CGAL_LIB}_ERROR_TAIL " CGAL was configured with WITH_${CGAL_LIB}=ON, but one of the dependencies of ${CGAL_LIB} was not configured properly." )
      endif(TARGET CGAL::${CGAL_LIB})
    else( WITH_${CGAL_LIB} )
      set( ${CGAL_LIB}_FOUND FALSE )
      set( CHECK_${CGAL_LIB}_ERROR_TAIL " Please configure CGAL using WITH_${CGAL_LIB}=ON." )
    endif( WITH_${CGAL_LIB} )
  endif()

  if ( NOT ${CGAL_LIB}_FOUND AND CHECK_CGAL_COMPONENT_MSG_ON_ERROR )
    message( ${CHECK_CGAL_COMPONENT_ERROR_TYPE} "${CHECK_CGAL_COMPONENT_ERROR_TITLE} The ${CGAL_LIB} library was not configured.${CHECK_${CGAL_LIB}_ERROR_TAIL}" )
  endif()

endmacro()

check_cgal_component("CGAL")

foreach( CGAL_COMPONENT ${CGAL_FIND_COMPONENTS} )
  list (FIND CGAL_CONFIGURED_LIBRARIES "CGAL_${CGAL_COMPONENT}" POSITION)
  if ("${POSITION}" STRGREATER "-1") # means: CGAL_COMPONENT is contained in list
    check_cgal_component("CGAL_${CGAL_COMPONENT}")
# TODO EBEB do something for supporting lib in check_component?
  endif()
endforeach()

# Starting with cmake 2.6.3, CGAL_FIND_COMPONENTS is cleared out when find_package returns.
# But we need it within UseCGAL.cmake, so we save it aside into another variable
set( CGAL_REQUESTED_COMPONENTS ${CGAL_FIND_COMPONENTS} )

# for preconfigured libs
set(CGAL_ENABLE_PRECONFIG "ON")
set(CGAL_SUPPORTING_3RD_PARTY_LIBRARIES "GMP;GMPXX;MPFR;ZLIB;OpenGL;LEDA;MPFI;RS;RS3;OpenNL;Eigen3;BLAS;LAPACK;QGLViewer;ESBTL;Coin3D;NTL;IPE")
set(CGAL_ESSENTIAL_3RD_PARTY_LIBRARIES "GMP;MPFR")

set(CGAL_DISABLE_GMP "")

include(${CGAL_MODULES_DIR}/CGAL_CreateSingleSourceCGALProgram.cmake)
include(${CGAL_MODULES_DIR}/CGAL_Macros.cmake)

# Temporary? Change the CMAKE module path
cgal_setup_module_path()

if( CGAL_DEV_MODE OR RUNNING_CGAL_AUTO_TEST )
  # Do not use -isystem for CGAL include paths
  set(CMAKE_NO_SYSTEM_FROM_IMPORTED TRUE)
  # Ugly hack to be compatible with current CGAL testsuite process (as of
  # Nov. 2017). -- Laurent Rineau
  include(CGAL_SetupFlags)
endif()

include("${CGAL_MODULES_DIR}/CGAL_enable_end_of_configuration_hook.cmake")
set(CGAL_EXT_LIB_Qt5_PREFIX "QT")
set(CGAL_EXT_LIB_Eigen3_PREFIX "EIGEN3")
set(CGAL_EXT_LIB_QGLViewer_PREFIX "QGLVIEWER")
set(CGAL_EXT_LIB_Coin3D_PREFIX "COIN3D")

if (NOT CGAL_IGNORE_PRECONFIGURED_GMP)
  set( GMP_FOUND           "TRUE" )
  set( GMP_USE_FILE        "" )
  set( GMP_INCLUDE_DIR     "/usr/include/x86_64-linux-gnu" )
  set( GMP_LIBRARIES       "/usr/lib/x86_64-linux-gnu/libgmp.so" )
  set( GMP_DEFINITIONS     "" )
endif()

if (NOT CGAL_IGNORE_PRECONFIGURED_MPFR)
  set( MPFR_FOUND           "TRUE" )
  set( MPFR_USE_FILE        "" )
  set( MPFR_INCLUDE_DIR     "/usr/include" )
  set( MPFR_LIBRARIES       "/usr/lib/x86_64-linux-gnu/libmpfr.so" )
  set( MPFR_DEFINITIONS     "" )
endif()

