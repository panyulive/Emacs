(require 'use-package)
(require 'bind-key)									   
;(require 'use-package)
;(global-set-key (kbd "C-/") 'ace-jump-mode)


(use-package ace-jump-mode
  :defer t
  :bind (( "C-/" . ace-jump-mode ))
  :init
  (autoload 'ace-jump-mode "ace-jump-mode" nil t)
  :config
 
  )



  
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs"))
(setq migemo-user-dictionary nil)
(setq migemo-coding-system 'utf-8)
(setq migemo-regex-dictionary nil)
(load-library "migemo")
(migemo-init)
(require 'popwin)
(require 'dired)
(require 'dired-x)
(require 'dired-toggle)
(require 'dired-details)
(require 'direx)

(setq display-buffer-function 'popwin:display-buffer)

;;diaplay-buffer-functionを変更したくない人向け
;;(setq special-display-function 'popwin:special-display-popup-window)

(setq popwin:special-display-config '(("*scratch*")
                                      ("*Dired\  Toggle*")))
;(display-buffer "*scratch*")

(push '(dired-mode :position left :width 40) popwin:special-display-config)

(setq direx:lead-icon   "  "
      direx:open-icon   "- "
      direx:closed-icon "+ ")
(push '(direx:direx-mode :position left :width 40 :dedicated t)
      popwin:special-display-config)

(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)
(global-set-key (kbd "C-x C-d") 'dired-toggle)
(dired-details-install)

(setq dired-details-hidden-string "")
(setq dired-details-hide-link-targets nil)

(defadvice find-dired-sentinel (after dired-details (proc state) activate)
  "find-diredでもdired-detailsを使えるようにする"
  (ignore-errors
    (with-current-buffer (process-buffer proc)
      (dired-details-activate))))

(require 'swoop)
(global-set-key (kbd "C-;")   'swoop)
(global-set-key (kbd "C-M-;") 'swoop-multi)
(global-set-key (kbd "M-;")   'swoop-pcre-regexp)
(global-set-key (kbd "C-S-;") 'swoop-back-to-last-position)
(global-set-key (kbd "M-6")   'swoop-migemo) ;; Option for Japanese match

;; 検索の移行
;; isearch     > press [C-;] > swoop
;; evil-search > press [C-;] > swoop
;; swoop       > press [C-;] > swoop-multi
(define-key isearch-mode-map (kbd "C-;") 'swoop-from-isearch)
;(define-key evil-motion-state-map (kbd "C-;") 'swoop-from-evil-search)
(define-key swoop-map (kbd "C-;") 'swoop-multi-from-swoop)

(setq sqoop-font-size-change: nil)

