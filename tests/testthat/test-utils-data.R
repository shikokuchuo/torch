context("utils-data")

test_that("tensor dataset", {
  x <- torch_randn(1000, 10)
  y <- torch_randn(1000)

  data <- tensor_dataset(x, y)

  expect_s3_class(data, "tensor_dataset")
  expect_s3_class(data, "dataset")
  expect_length(data, 1000)

  sub <- data[1:2]
  expect_tensor_shape(sub[[1]], c(2, 10))
  expect_tensor_shape(sub[[2]], c(2))
})

test_that("create a dataset with private and active methods", {
  ds <- dataset(
    "my_dataset",
    initialize = function() {

    },
    .getitem = function(i) {
      private$pvt_method()
    },
    .length = function() {
      self$actv_len
    },
    private = list(
      pvt_method = function() {
        1:10
      }
    ),
    active = list(
      actv_len = function() {
        10
      }
    )
  )

  d <- ds()
  expect_equal(d[1], 1:10)
  expect_equal(length(d), 10)
})

test_that("dataset_subset works", {
  x <- torch_randn(50, 10)
  y <- torch_randn(50)

  data <- tensor_dataset(x, y)
  data_subset <- dataset_subset(data, 1:14)
  expect_equal(length(data_subset), 14)
  expect_tensor(data_subset[1:4][[1]])
  expect_equal(nrow(data_subset[1:4][[1]]), 4)
})

test_that("getbatch will get a vector of integers", {
  data <- dataset(
    initialize = function() {},
    .getbatch = function(indexes) {
      expect_true(is.integer(indexes))
    },
    .length = function() {
      100
    }
  )

  expect_true(data()[list(1, 2, 3, 4)])
})

test_that("subset without getbatch works", {
  x <- torch_randn(50)

  ds <- dataset("my_dataset",
    initialize = function(x) {
      self$x <- x
    },
    .getitem = function(i) {
      if (length(i) > 1) {
        stop("Can only get a single item!")
      }

      self$x[i]
    },
    .length = function() {
      length(self$x)
    }
  )

  data <- ds(x)
  ds_subset <- dataset_subset(data, indices = 20:30)
  expect_equal(data[20], ds_subset[1])

  dl <- dataloader(ds_subset, batch_size = 10)
  expect_length(coro::collect(dl), 2)
})

test_that("subset works with getbatch", {
  x <- torch_randn(50)

  ds <- dataset("my_dataset",
    initialize = function(x) {
      self$x <- x
    },
    .getbatch = function(idx) {
      self$x[idx]
    },
    .length = function() {
      length(self$x)
    }
  )

  data <- ds(x)
  ds_subset <- dataset_subset(data, indices = 20:30)
  expect_equal_to_tensor(data[c(20, 21, 22)], ds_subset[c(1, 2, 3)])

  dl <- dataloader(ds_subset, batch_size = 5)
  expect_length(coro::collect(dl), 3)
})

test_that("datasets have a custom print method", {
  data <- dataset(
    initialize = function() {},
    .getbatch = function(indexes) {
      expect_true(is.integer(indexes))
    },
    .length = function() {
      100
    },
    parent_env = .GlobalEnv
  )

  expect_output(print(data), regexp = "dataset_generator")
})

test_that("dataset subset adds more classes", {
  minimal_dataset <- dataset(
    "minimal",
    initialize = function() {
      self$data <- torch_tensor(1:5)
    },
    .length = function() {
      self$data$size()[[1]]
    }
  )
  testing <- minimal_dataset()
  expect_equal(class(testing), c("minimal", "dataset", "R6"))
  testing_sub <- dataset_subset(testing, 1:2)
  expect_equal(
    class(testing_sub), 
    c("minimal_subset", "dataset_subset", "dataset", "R6")
  )
})

test_that("dimensions are preserved", {
  ds <- tensor_dataset(torch_rand(11,3), torch_rand(11,1))
  loader <- dataloader(ds, batch_size=10, shuffle=TRUE)
  
  iter <- dataloader_make_iter(loader)
  x <- dataloader_next(iter)
  expect_equal(dim(x[[1]]), c(10, 3))
  expect_equal(dim(x[[2]]), c(10, 1))
  
  x <- dataloader_next(iter)
  expect_equal(dim(x[[1]]), c(1, 3))
  expect_equal(dim(x[[2]]), c(1, 1))
})

test_that("can get a single element using `[[`", {
  # this should call getitem and drop the batch dimension when possible.
  ds <- tensor_dataset(torch_rand(11,3), torch_rand(11,1))
  expect_equal(dim(ds[[1]][[1]]), 3)
})

test_that("can have a dataset named torch_tensor", {

  ds <- dataset("torch_tensor",
    initialize = function() {
    },
    .getitem = function(id) {
      torch::torch_tensor(1)
    },
    .length = function() 1L
  )
  
  expect_no_error({
    a <- ds()
  })
  
})
