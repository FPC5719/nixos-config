;; Basic

(use-package counsel)

(use-package ivy
  :init
  (ivy-mode 1)
  (counsel-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq search-default-mode #'char-fold-to-regexp)
  (setq ivy-count-format "(%d/%d) ")
  :bind
  (("C-s"       . 'swiper)
   ("C-x b"     . 'ivy-switch-buffer)
   ("C-c v"     . 'ivy-push-view)
   ("C-c s"     . 'ivy-switch-view)
   ("C-c V"     . 'ivy-pop-view)
   ("C-x C-@"   . 'counsel-mark-ring)
   ("C-x C-SPC" . 'counsel-mark-ring)
   :map minibuffer-local-map
   ("C-r"       . counsel-minibuffer-history)))

(use-package amx
  :init (amx-mode))

(use-package mwim
 :bind
 ("C-a" . mwim-beginning-of-code-or-line)
 ("C-e" . mwim-end-of-code-or-line))

(use-package company
  :init (global-company-mode)
 :config
 (setq company-minimum-prefix-length 3)
 (setq company-tooltip-align-annotations t)
 (setq company-idle-delay 0.0)
 (setq company-show-numbers t)
 (setq company-selection-wrap-around t)
 (setq company-transformers '(company-sort-by-occurrence)))

(use-package xclip
  :config (xclip-mode))

(use-package direnv
  :config (direnv-mode))


;; Global key bindings
(global-set-key (kbd "C-t") nil) ; Avoid swap char
(global-set-key (kbd "C-j") nil)
(global-set-key (kbd "C-q") nil)
(global-set-key (kbd "C-j C-r") 'replace-regexp)
(global-set-key (kbd "C-j C-a") 'align-regexp)
(global-set-key (kbd "C-j C-c") 'comment-region)
(global-set-key (kbd "C-j C-u") 'uncomment-region)
(global-set-key (kbd "C-j C-t") 'revert-buffer)

(defun eshell-new-h ()
  "Open eshell horizontally"
  (interactive)
  (split-window-horizontally)
  (other-window 1)
  (eshell))
(defun eshell-new-v ()
  "Open eshell vertically"
  (interactive)
  (split-window-vertically)
  (other-window 1)
  (eshell))
(global-set-key (kbd "C-x 5 s") 'eshell-new-h)
(global-set-key (kbd "C-x 4 s") 'eshell-new-v)

(use-package esh-autosuggest
  :hook (eshell-mode . esh-autosuggest-mode))

(provide 'init-basic)
