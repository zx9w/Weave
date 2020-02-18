(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq custom-file (make-temp-file "emacs-custom"))

(setq inhibit-startup-screen t)

(global-visual-line-mode 1)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore)

(setq backup-directory-alist '(("." . "~/Projects/Emacs/gomacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      vc-make-backup-files t ; TODO from sachachua not sure what it does 
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; how many of the old versions to keep
      )

(display-time-mode -1)     

(eval-when-compile
  (require 'use-package))

(use-package evil
  :ensure t)

(evil-normal-state)
