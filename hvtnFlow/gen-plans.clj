(ns gen-plan
  (:require [clojure.string :as s]
            [clojure.java.io :as io]
            [clojure.zip :as zip]))

(defn boolean-combinations [bools oldstyle]
  "Given a list of boolean names, generate a list of + and - combinations.
  When oldstyle is true, the combinations will be prefixed with ! when negated."
  (let [len (count bools)
        plus-minus ['- '+]
        combs (fn combs [n]
                (if (zero? n)
                  [[]]
                  (for [smaller (combs (dec n))
                        pm plus-minus]
                    ;(cons (str (nth bools (dec n)) pm) smaller))))]
                    (conj smaller
                         (if oldstyle
                           (str (if (= '- pm) "!" "") (nth bools (dec n)) "+")
                           (str (nth bools (dec n)) pm))))))]
        (combs len)))

(defn boolean-strings [bools oldstyle]
  "Create a set of boolean strings from the boolean combinations.
  Example:
    (boolean-strings [\"a\" \"b\"] false)
      => (\"a-b-\" \"a-b+\" \"a+b-\" \"a+b+\")

  Example:
    (boolean-strings [\"a\" \"b\"] true)
      => (\"(a-b-)\" \"(a-b+)\" \"(a+b-)\" \"(a+b+)\")"

  (for [comb (boolean-combinations bools oldstyle)]
    (if oldstyle
      (str "(" (s/join "&" comb) ")")
      (apply str comb))))

; ---------

(defn create-zipper [specification]
  (zip/zipper #(contains? % :children) :children nil specification))

(defn normalize [s]
  (.normalize (.toPath (io/file s))))

(defn stat-string [loc]
  (let [node (zip/node loc)
        gate (:gate node)
        path (rest (zip/path loc))
        gate-path (if (empty? path)
                    gate
                    (normalize
                      (s/join "/"
                              [(s/join "/"
                                       (map :gate (filter #(not (nil? %)) path))) gate])))]
    (if (nil? gate)
      "" ; allow blank subset (see AnalysisPlan40)
      (str gate-path ":Count"))))

(defn path-loc
  "Like zip/path, but returns a seq over zipper locs instead of the nodes and includes the current loc."
  [loc]
  (reverse
    (take-while #(not (nil? (zip/up %)))
                (iterate zip/up loc))))

(defn print-path [sortid id description loc]
  (when (not (zip/children loc))
    (let [locs (path-loc loc)]
      (print (str sortid "\t" id "\t" description "\t"))
      (println
        (s/join "\t"
                (interleave (map #(:name (zip/node %)) locs) (map stat-string locs)))))))

(defn print-subsets [sortid id description z]
  (loop [loc z]
    (if (not (zip/end? loc))
      (do
        (print-path sortid id description loc)
        (recur (zip/next loc))))))

(defn print-headers []
  (let [headers ["analysisPlanSort" "analysisPlanId" "description"
                 "NAME1" "STAT1"
                 "NAME2" "STAT2"
                 "NAME3" "STAT3"
                 "NAME4" "STAT4"
                 "NAME5" "STAT5"
                 "NAME6" "STAT6"
                 "NAME7" "STAT7"
                 "NAME8" "STAT8"
                 "NAME9" "STAT9"
                 "NAME10" "STAT10"]]
    (println (s/join "\t" headers))))


(defn print-plan [specification]
  (let [z (create-zipper specification)
        sortid (:sort-id specification)
        id (:id specification)
        desc (:description specification)]
    (with-open [f (io/writer (io/file "plans" (str sortid ".tsv")))]
      (binding [*out* f]
        (print-headers)
        (print-subsets sortid id desc z)))))


(defn print-plans [ids]
  (let [plans (load-file "analysis-plans.clj")]
    (dorun
      (for [plan plans]
        (if (or (empty? ids) (some #(= (:id plan) %) ids))
          (print-plan plan))))))

; ---------

(defn -main [& args]
  (if (empty? args)
    (print-plans nil)
    (print-plans (first args))))

(-main *command-line-args*)
