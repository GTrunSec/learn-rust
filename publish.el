;;; publish.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 GTrunSec
;;
;; Author: GTrunSec <https://github.com/gtrunsec>
;; Maintainer: GTrunSec <gtrunsec@hardenedlinux.org>
;; Created: April 15, 2021
;; Modified: April 15, 2021
;; Version: 0.0.1
;; Keywords: Symbol’s value as variable is void: finder-known-keywords
;; Homepage: https://github.com/gtrun/publish
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(require 'package)
(package-initialize)
(unless package-archive-contents
  (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (package-refresh-contents))
(dolist (pkg '(org-plus-contrib ox-hugo))
  (unless (package-installed-p pkg)
    (package-install pkg)))

(require 'org)
(require 'ox-publish)
(require 'org-id)

(setq org-publish-project-alist
      '(
        ("my-learning-rust"
         :base-directory "./docs"
         :publishing-function org-md-publish-to-md
         :publishing-directory "./docs"
         :base-extension "org"
         )
        ))

(require' find-lisp)
(with-eval-after-load 'ox
  (require 'ox-hugo)
  (setq org-src-preserve-indentation t))

;; (defun gt/republish ()
;;   (let ((current-prefix-arg 4)
;;         (make-backup-files nil)
;;         (org-export-with-broken-links 1)
;;         (org-id-locations-file-relative -1)
;;         ;;(org-id-extra-files (find-lisp-find-files "./braindump" "\.org$"))
;;         (org-id-locations-file (expand-file-name ".orgids" "./"))
;;         (org-hugo-base-dir "..")
;;         )
;;     ))

(defun gt/publish (file)
  (with-current-buffer (find-file-noselect file)
    (setq org-id-locations-file (expand-file-name ".orgids" "./"))
    (setq org-hugo-base-dir "..")
    (let ((org-id-extra-files (find-lisp-find-files "../braindump" "\.org$"))
          ;;(org-id-extra-files (find-lisp-find-files "~/Dropbox/org-notes/braindump" "\.org$"))
          )
      (org-hugo-export-wim-to-md))))

(provide 'publish)
;;; publish.el ends here
