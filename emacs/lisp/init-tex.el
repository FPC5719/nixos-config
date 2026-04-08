(defun my-tex-hook ()
  (setq TeX-global-pdf-mode t)
  (setq TeX-engine 'xetex)
  (add-to-list 'TeX-command-list
               '("XeLaTeX" "%'xelatex%(mode)%' %t"
                 TeX-run-TeX nil t))
  (setq TeX-command-default "XeLaTeX"))

(use-package tex
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq TeX-output-view-style (quote (("^pdf$" "." "evince %o %(outpage)"))))
  :hook
  (TeX-mode . my-tex-hook))

(provide 'init-tex)
