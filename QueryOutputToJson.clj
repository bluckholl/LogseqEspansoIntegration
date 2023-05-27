(require '[cheshire.core :as json])
(println (json/generate-string *input* {:pretty true}))