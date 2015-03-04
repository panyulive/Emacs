(require 'redo+)
(require 'undo-tree)

(setq undo-no-redo t)
;; undoする情報を保持する量
(setq undo-limit 60000)
(setq undo-strong-limit 90000)

(global-undo-tree-mode)

;;C-x u undo-tree-mode
