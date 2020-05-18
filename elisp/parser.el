(require 'ox)
(require 'seq)


;; ================================================================================
;; Org utility functions
;; ================================================================================

(defun get-current-level (element)
  "Get the level to which ELEMENT belongs"
  (let ((headline (org-element-lineage element '(headline) t)))
    (if headline
        (org-element-property :level headline) 0)))

(defun get-affiliated (element)
  (buffer-substring (org-element-property :begin element)
                    (org-element-property :post-affiliated element)))

(defun get-post-blank (element)
  (org-element-property :post-blank element))


(defun delete-comments (doc)
  "Remove comments, comment blocks, and commented trees from Org document tree DOC"
  (org-element-map doc '(comment comment-block) 'org-element-extract-element)
  (org-element-map doc 'headline
    (lambda (hl)
      (and (org-element-property :commentedp hl)
           (org-element-extract-element hl)))))

(defun headline-p (element)
  (eq (org-element-type element) 'headline))

(defun item-p (element)
  (eq (org-element-type element) 'item))

;; Property drawers
;; --------------------------------------------------------------------------------
(defun make-node-property (key value)
  "Return a node property"
  (org-element-create
       'node-property
       (list :key key :value value)))

(defun make-property-drawer (&rest nodes)
  "Return a property drawer with property nodes NODES"
  (apply 'org-element-create
         'property-drawer nil nodes))

;; Headlines
;; --------------------------------------------------------------------------------
(defun make-headline (title level &rest children)
  "Return a headline with the given TITLE and LEVEL"
  (apply 'org-element-create
         'headline (list :title title :level level)
         children))

(defun make-headline-unnumbered (title level)
  "Return an unnumbered headline with the given TITLE and LEVEL"
  (make-headline
   title level
   (make-property-drawer
    (make-node-property "UNNUMBERED" t))))


;; Paragraphs
;; --------------------------------------------------------------------------------
(defun make-paragraph (contents &optional post-blank)
  "Return a paragraph with the given CONTENTS"
  (let ((props (and post-blank (list :post-blank post-blank))))
    (apply 'org-element-create
           'paragraph props contents)))

;; Links
;; --------------------------------------------------------------------------------
(defun make-link (type path)
  "Return a link"
  (org-element-create 'link (list :type type :path path)))


(defun make-par-link (type path &optional affiliated post-blank)
  "Return a paragraph with a link"
  (let ((link (make-link type path))
        (contents))
    (setq contents (if affiliated (list affiliated link) link))
    (make-paragraph contents post-blank)))



;; ================================================================================
;; XXX keywords
;; ================================================================================


(defun xxx-keyword-p (element)
  "Returns t if ELEMENT is a xxx-keyword"
  (and (eq (org-element-type element) 'keyword)
       (string= (org-element-property :key element) "XXX")))

(defun xxx-col-p (element)
  "Returns t if ELEMENT is a col xxx-keyword
It only works after parse-xxx-keywords"
  (and (xxx-keyword-p element)
       (string= (org-element-property :xxx-type element) "col")))

(defun parse-xxx-keywords (doc)
  "Add xxx-type and xxx-value properties to a xxx-keyword"
  (org-element-map doc 'keyword
    (lambda (keyword)
      (let ((type)
            (text)
            (value))
        (when (xxx-keyword-p keyword)
          (setq text (org-element-property :value keyword))
          (when (string-match
                 "[[:blank:]]*\\([^[:blank:]]+\\)\\(?:[[:blank:]]+\\(.*\\)\\)?[[:blank:]]*\\'" text)
            (setq keyword (org-element-put-property keyword :xxx-type (match-string 1 text)))
            (setq keyword (org-element-put-property keyword :xxx-value (match-string 2 text)))))))))


(defun process-xxx-keywords (doc)
  "Get the different parts of a XXX keyword and call the appropriate handler"
  (parse-xxx-keywords doc)
  (org-element-map doc 'keyword
    (lambda (keyword)
      (let ((type)
            (text)
            (value))
        (when (xxx-keyword-p keyword)
          (setq type (org-element-property :xxx-type keyword))
            (cond ((string= type "col") (xxx-col keyword))
                  ((string= type "fig") (xxx-fig keyword))
                  (t nil)))))))


;; Figures
;; --------------------------------------------------------------------------------
(defun fig-file-path (value lang)
  (if (string-match "\\*" value)
      (replace-match (or lang "\\LANG") nil t value)
    value))

(defun xxx-fig (element)
  (org-element-set-element
   element
   (make-par-link
    "file"
    (fig-file-path (org-element-property :xxx-value element) nil)
    (get-affiliated element)
    (get-post-blank element))))


;; Columns
;; --------------------------------------------------------------------------------

(defun find-all-siblings (element)
  "Return a list with all siblings of ELEMENT including itself"
  (org-element-contents (org-element-property :parent element)))

(defun find-col-contents (element)
  "Return the contents of a xxx col

Return all siblings after ELEMENT and before a headline, a list item or
another xxx col."
  (let ((siblings (find-all-siblings element))
        (before t)
        (after))
    (seq-filter
     (lambda (e)
       (cond
        (before (progn
                  (when (eq e element)
                    (setq before nil))
                  nil))
        (after nil)
        (t (if (or (headline-p e) (item-p e) (xxx-col-p e))
               (progn (setq after t) nil)
             t))))
     siblings)))

(defun xxx-col (element)
  (let ((contents (find-col-contents element))
        (minipage (org-element-create 'special-block (list :type "minipage" :raw-value "")))
        (affiliated (get-affiliated element)))
    (apply 'org-element-adopt-elements minipage
           (seq-map #'org-element-extract-element contents))
    (setq minipage (if affiliated (list affiliated minipage) minipage))
    (org-element-set-element
     element
     (apply 'org-element-create
      'paragraph nil
      minipage))))


;; ================================================================================
;; Problems
;; ================================================================================

(defun handle-section (section)
  "Collect answers within a section.

Extract answers (level 3 headlines) and add them to the contents of a new section
with the same title as the original one.
"
  (let ((answers)
        (new-section))
    (setq answers
          (org-element-map section 'headline
            (lambda (hl)
              (when (= (org-element-property :level hl) 3)
                (org-element-extract-element hl)))))
    (when answers
      (setq new-section (make-headline (org-element-property :title section) 2))
      (apply 'org-element-adopt-elements new-section answers))))


(defun make-solutions-section (doc)
  "Make a solutions section.

Iterate over first level sections and process then with handle-section.
Collect the results and add them to a new solutions section at the end
of the document."
  (let ((sections)
        (new-section))
    (setq sections
          (org-element-map doc 'headline
            (lambda (hl)
              (and (= (org-element-property :level hl) 1)
                   (handle-section hl)))))
    (when sections
      (setq new-section (make-headline-unnumbered "{{{Solutions}}}" 1))
      (apply 'org-element-adopt-elements new-section sections))))

(defun prepare-buffer ()
  "Parse problems document"
  (let ((doc))
    (org-export-expand-include-keyword)
    (setq doc (org-element-parse-buffer))
    (delete-comments doc)
    (org-element-adopt-elements doc (make-solutions-section doc))
    (process-xxx-keywords doc)
    (org-element-interpret-data doc)))

(defun preprocess-probl ()
  "Replace buffer with preprocessed probl document"
  (let ((new (prepare-buffer)))
    (erase-buffer)
    (insert new)))


;; (remove-hook 'org-export-before-parsing-hook 'preprocess-probl)
;; (add-hook 'org-export-before-parsing-hook 'preprocess-probl)


(defun print-tree (tree &optional indent)
  (setq indent (or indent 0))
  (dolist (node tree)
    (princ (format "%s%s\n" (make-string (* 2 indent) ? ) (org-element-type node)) (get-buffer "*scratch*"))
    (setq contents (org-element-contents node))
    (when contents
      (print-tree contents (+ indent 1)))))
