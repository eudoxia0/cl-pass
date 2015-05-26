# cl-pass

cl-pass is a password hashing and verification library. The source code was
originally part of [hermetic](https://github.com/eudoxia0/hermetic), and was
factored out to allow other libraries to use it.

# Usage

```lisp
cl-user> (cl-pass:hash "test")
"PBKDF2$sha256:20000$5cf6ee792cdf05e1ba2b6325c41a5f10$19c7f2ccb3880716bf7cdf999b3ed99e07c7a8140bab37af2afdc28d8806e854"
cl-user> (cl-pass:check-password "test" *)
t
cl-user> (cl-pass:check-password "nope" **)
nil
```

# License

Copyright (c) 2014-2015 Fernando Borretti (eudoxiahp@gmail.com)

Licensed under the MIT License.
