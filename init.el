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

(add-to-load-path "clone-package")

(require 'init-loader)
(init-loader-load "~/.emacs.d/conf")

(custom-set-variables
 '(shell-pop-shell-type (quote ("eshell" "*eshell*" (lambda nil (eshell)))))
 '(yas-trigger-key "TAB"))

(custom-set-faces
  '(howm-mode-title-face ((t (:foreground "Yellow")))))

(server-start)
