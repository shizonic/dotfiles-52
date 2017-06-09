;; Use custom file at alternate path
(setq custom-file "~/.emacs.d/custom.el")
(if (file-exists-p custom-file)
    (load custom-file))

;; Remove banners
(setq inhibit-startup-message t)

;; Disable backups
(setq backup-inhibited t)
(setq auto-save-default nil)

;; Initialize package.el with custom repositories.
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(package-initialize)

;; Require req-package to make .emacs manageable.
(unless (package-installed-p 'req-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (package-install 'req-package))
(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)
(require 'req-package)

;; Packages
(let ((loaded (mapcar #'file-name-sans-extension (delq nil (mapcar #'car load-history)))))
  (dolist (file (directory-files "~/.dotfiles/emacs/packages" t ".+\\.elc?$"))
    (let ((library (file-name-sans-extension file)))
      (unless (member library loaded)
	(load library nil t)
	(push library loaded)))))
(req-package-finish)

;; Use y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)