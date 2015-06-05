(require 'swoop)
(global-set-key (kbd "C-;")   'swoop)
(global-set-key (kbd "C-M-;") 'swoop-multi)
(global-set-key (kbd "M-;")   'swoop-pcre-regexp)
(global-set-key (kbd "C-S-;") 'swoop-back-to-last-position)
(global-set-key (kbd "H-6")   'swoop-migemo) ;; Option for Japanese match

;; 検索の移行
;; isearch     > press [C-;] > swoop
;; evil-search > press [C-;] > swoop
;; swoop       > press [C-;] > swoop-multi
(define-key isearch-mode-map (kbd "C-;") 'swoop-from-isearch)
;(define-key evil-motion-state-map (kbd "C-;") 'swoop-from-evil-search)
(define-key swoop-map (kbd "C-;") 'swoop-multi-from-swoop)

