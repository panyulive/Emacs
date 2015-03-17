(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

; Initialize
(package-initialize)
(fset 'package-desc-vers 'package--ac-desc-version)
; melpa.el
;(require 'melpa)

;(require 'auto-install)
;(setq auto-install-directry "~/.emacs.d/auto-install/")
;(auto-install-update-emacswiki-package-name t)
;(auto-install-compatibility-setup)
