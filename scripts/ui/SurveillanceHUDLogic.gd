extends RefCounted
class_name SurveillanceHUDLogic
## Helper de calcul pour SurveillanceHUD. Pas autoload — instancié
## par le HUD au _ready. Testable directement.


## Combien de dots allumés pour une valeur donnée, en répartissant
## linéairement entre 0 et max sur total_dots cases. Clampe au max.
func compute_dots(value: int, max_value: int, total_dots: int) -> int:
	if max_value <= 0 or total_dots <= 0:
		return 0
	var v: int = clampi(value, 0, max_value)
	return int(floor(float(v) * float(total_dots) / float(max_value)))


## Libellé textuel selon le palier le plus haut franchi.
## Renvoie chaîne vide si en deçà du seuil donné.
func line_label(value: int, palier_min: int) -> String:
	if value < palier_min:
		return ""
	if value >= 90:
		return "EXTRACTION IMMINENTE"
	if value >= 75:
		return "TU ES SUIVIE"
	if value >= 50:
		return "ÉCOUTE ACTIVE"
	if value >= 25:
		return "ÉCOUTE PARTIELLE"
	return ""
