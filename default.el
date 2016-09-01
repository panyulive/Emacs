(require 'cl)
(setq exec-path (cons "/usr/local/bin"exec-path))

(defvar user-emacs-directory "~/.emacs.d/")

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

(add-to-load-path "clone-package" "themes" "elpa")


;; load environment value
(load-file (expand-file-name "~/.emacs.d/shellenv.el"))
(dolist (path (reverse (split-string (getenv "PATH") ":")))
  (add-to-list 'exec-path path))

(cua-mode t)
(setq cua-enable-cua-keys nil)

(require 'use-package)
(require 'bind-key)

(bind-key "C-h" 'delete-backward-char)

(use-package howm
  :bind (("C-c , ," . howm-menu))
  :init
  ;;howm Config
  (setq howm-menu-lang 'ja)
  ;; howm directoryの場所
  (setq howm-directory "~/Dropbox/emacs/howm/")

  :config
  (mapc
   (lambda (f)
     (autoload f
       "howm" "Hitori Otegaru Wiki Modoki" t))
   '(howm-menu howm-list-all howm-list-recent
               howm-list-grep howm-create
               howm-keyword-to-kill-ring))

  (defun howm-save-buffer-and-kill ()
    "howmメモを保存と同時に閉じます。"
    (interactive)
    (when (and (buffer-file-name)
               (string-match "\\.txt" (buffer-file-name)))
      (save-buffer)
      (kill-buffer nil)))

  ;; C-c C-cでメモの保存と同時にバッファを閉じる
  (define-key howm-mode-map (kbd "C-c C-c") 'howm-save-buffer-and-kill)

  )

(use-package web-mode
  :config
  )

(use-package php-mode
  :config
  )

(use-package shell-pop
  :config
  (setq shell-pop-shell-type '("eshell" "*eshell*" (lambda () (eshell))))
  )
