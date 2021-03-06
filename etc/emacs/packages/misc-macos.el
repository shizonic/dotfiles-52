;; -*- lexical-binding: t -*-

(gemacs-when-compiletime (eq system-type 'darwin)
  (setq dired-use-ls-dired nil)

  (when (display-graphic-p)
    (defun mac-toggle-fullscreen ()
      (interactive)
      (when (eq window-system 'mac)
        (set-frame-parameter
         nil 'fullscreen
         (when (not (frame-parameter nil 'fullscreen)) 'fullscreen))))

    (eval-when-compile
      (defvar mac-command-modifier)
      (defvar mac-command-key-is-meta)
      (defvar mac-option-modifier)
      (defvar mac-option-key-is-meta))

    (setq mac-command-key-is-meta nil)
    (setq mac-command-modifier 'super)
    (setq mac-option-key-is-meta t)
    (setq mac-option-modifier 'meta)

    (global-set-key (kbd "s-v") 'yank)
    (global-set-key (kbd "s-c") 'evil-yank)
    (global-set-key (kbd "s-w") 'delete-window)
    (global-set-key (kbd "s-W") 'delete-frame)
    (global-set-key (kbd "s-n") 'make-frame))


  (use-package osx-trash
    :demand t

    :preface
    (eval-when-compile
      (declare-function osx-trash-setup nil))

    :config
    (osx-trash-setup))


  (use-package pbcopy
    :demand t

    :preface
    (eval-when-compile
      (declare-function turn-on-pbcopy nil))

    :config
    (turn-on-pbcopy)))
