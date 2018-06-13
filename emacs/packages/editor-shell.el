(use-package exec-path-from-shell
  :defer 2
  :ensure t

  :preface
  (eval-when-compile
    (declare-function exec-path-from-shell-initialize nil))

  :config
  ;; Disable environment check during startup because .rbenv/.pyenv need to be
  ;; initialized as part of the interactive shell, otherwise anything that were
  ;; installed as part of the distro package and contains shebangs referencing
  ;; #!/usr/bin/env will be broken because python/ruby is now the rbenv/pyenv's
  ;; which may not the contain necessary modules required by the distro package.
  (setq exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-initialize))


(use-package keychain-environment
  :after exec-path-from-shell
  :ensure t

  :preface
  (eval-when-compile
    (declare-function keychain-refresh-environment nil))

  :config
  (let ((shell (getenv "SHELL")))
    (progn
      (setenv "SHELL" "/bin/sh")
      (keychain-refresh-environment)
      (setenv "SHELL" shell))))