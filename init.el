(require 'cl)
(setq exec-path (cons "/usr/local/bin"exec-path))

(tool-bar-mode 0)
(scroll-bar-mode 0)

(defvar user-emacs-directory "~/.emacs.d/")

(require 'package)
;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))
;; 初期化
(package-initialize)

(defvar my-package-list
  '(auto-complete
	exec-path-from-shell
	direx
	helm
	init-loader
	magit
	popwin
	popup
	shell-pop
	open-junk-file
	web-mode
	ace-jump-mode
	yasnippet))

(let ((not-installed
       (loop for package in my-package-list
             when (not (package-installed-p package))
             collect package)))
  (when not-installed
    (package-refresh-contents)
    (dolist (package not-installed)
      (package-install package))))


(setq make-backup-files t)
(setq backup-directory-alist
  (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
	backup-directory-alist))



(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "clone-package" "themes")

(require 'init-loader)
(init-loader-load "~/.emacs.d/conf")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
	("357d5abe6f693f2875bb3113f5c031b7031f21717e8078f90d9d9bc3a14bcbd8" "12722541c8998f056b761bf63a92216aaf4610e4eb1afe7991842a31fa28b6d8" "90d329edc17c6f4e43dbc67709067ccd6c0a3caa355f305de2041755986548f2" "3dafeadb813a33031848dfebfa0928e37e7a3c18efefa10f3e9f48d1993598d3" "05c3bc4eb1219953a4f182e10de1f7466d28987f48d647c01f1f0037ff35ab9a" default)))
 '(helm-mode t)
 '(js2-auto-indent-p t)
 '(js2-basic-offset 2)
 '(js2-enter-indents-newline t)
 '(js2-indent-on-enter-key t)
 '(js2-indent-tabs-mode nil)
 '(js2-mirror-mode t)
 '(shell-pop-shell-type (quote ("eshell" "*eshell*" (lambda nil (eshell)))))
 '(yas-trigger-key "TAB"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(howm-mode-title-face ((t (:foreground "Yellow")))))

(server-start)
