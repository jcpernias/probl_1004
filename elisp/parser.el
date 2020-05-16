(require 'org-element)
(require 'seq)

(defun delete-comments (doc)
  "Remove comments, comment blocks, and commented trees from Org document tree DOC"
  (org-element-map doc '(comment comment-block) 'org-element-extract-element)
  (org-element-map doc 'headline
    (lambda (hl)
      (and (org-element-property :commentedp hl)
           (org-element-extract-element hl)))))


(defun make-heading-unnumbered (title level)
  "Build an umnnumbered heading with the given TITLE and LEVEL"
  (let ((props (list :title title :level level :post-blank 1)))
    (org-element-create
     'headline props
     (org-element-create
      'property-drawer nil
      (org-element-create
       'node-property
       (list :key "UNNUMBERED" :value "t"))))))

(defun make-heading (title level)
  "Build a heading with the given TITLE and LEVEL"
  (org-element-create 'headline (list :title title :level level :post-blank 1)))


(defun handle-section (section)
  (let ((answers)
        (new-section))
    (setq answers
          (org-element-map section 'headline
            (lambda (hl)
              (when (= (org-element-property :level hl) 3)
                (org-element-extract-element hl)))))
    (when answers
      (setq new-section (make-heading (org-element-property :title section) 2))
      (apply 'org-element-adopt-elements new-section answers))))


(defun make-solutions-section (doc)
  (let ((sections)
        (new-section))
    (setq sections
          (org-element-map doc 'headline
            (lambda (hl)
              (and (= (org-element-property :level hl) 1)
                   (handle-section hl)))))
    (when sections
      (setq new-section (make-heading-unnumbered "{{{Solutions}}}" 1))
      (apply 'org-element-adopt-elements new-section sections))))

(defun parse-probl ()
  "Parse problems file"
  (let ((doc))
    (org-export-expand-include-keyword)
    (setq doc (org-element-parse-buffer))
    (delete-comments doc)
    (org-element-adopt-elements doc (make-solutions-section doc))
    (org-element-interpret-data doc)))

(defun preprocess-probl ()
  "Replace buffer with preprocessed probl document"
  (let ((new (parse-probl)))
    (erase-buffer)
    (insert new)))
