# app/CMakeLists.txt

add_subdirectory(algorithms)

add_executable(app app.cc)
target_link_libraries(app PRIVATE
  app_io_cc_proto
  algorithm_impl_lib
  greedy
  bmatching_lib
  hgr_reader
  random_lib
  absl::flags
  absl::flags_parse
  absl::statusor
  easyloggingpp_lib
)

if(BMATCHING_USE_TCMALLOC)
  target_link_libraries(app PRIVATE tcmalloc)
endif()
