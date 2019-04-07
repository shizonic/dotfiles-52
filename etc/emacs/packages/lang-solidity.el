(use-package solidity-mode
  :mode ("\\.sol\\'" . solidity-mode)
  :straight t

  :init
  (setq solidity-flycheck-solium-checker-active t)
  (with-eval-after-load 'company
    (defun gr/setup-company-solidity ()
      (set (make-local-variable 'company-backends) '(company-solidity)))
    (add-hook 'solidity-mode-hook 'gr/setup-company-solidity)))