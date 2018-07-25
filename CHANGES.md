CHANGES
=======

2018/07/23
----------

A test was added to demonstrate Issue #1. When compiled with MinGW, bspatch.exe fails to
find files whose path lengths exceed 260 characters. Run the test thus:

```
make test-long-paths
```


