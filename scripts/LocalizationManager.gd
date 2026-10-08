extends Node

enum Language { ENGLISH, UKRAINIAN, POLISH }

var current_language: Language = Language.ENGLISH

var translations := {
	"menu_title": {
		Language.ENGLISH: "Ukraine × Poland",
		Language.UKRAINIAN: "Україна × Польща",
		Language.POLISH: "Ukraina × Polska"
	},
	"menu_subtitle": {
		Language.ENGLISH: "BOARD GAME",
		Language.UKRAINIAN: "НАСТІЛЬНА ГРА",
		Language.POLISH: "GRA PLANSZOWA"
	},
	"menu_description": {
		Language.ENGLISH: "Learn about each other through play",
		Language.UKRAINIAN: "Дізнайтеся один про одного через гру",
		Language.POLISH: "Poznajcie się nawzajem przez zabawę"
	},
	"menu_play": {
		Language.ENGLISH: "PLAY",
		Language.UKRAINIAN: "ГРАТИ",
		Language.POLISH: "GRAJ"
	},
	"menu_settings": {
		Language.ENGLISH: "SETTINGS",
		Language.UKRAINIAN: "НАЛАШТУВАННЯ",
		Language.POLISH: "USTAWIENIA"
	},
	"menu_quit": {
		Language.ENGLISH: "QUIT",
		Language.UKRAINIAN: "ВИХІД",
		Language.POLISH: "WYJŚCIE"
	},
	"setup_title": {
		Language.ENGLISH: "PLAYER SETUP",
		Language.UKRAINIAN: "НАЛАШТУВАННЯ ГРАВЦІВ",
		Language.POLISH: "USTAWIENIA GRACZY"
	},
	"setup_description": {
		Language.ENGLISH: "Add 2–20 local hot-seat players. Turn order follows this list.",
		Language.UKRAINIAN: "Додайте від 2 до 20 гравців. Порядок ходів відповідає списку.",
		Language.POLISH: "Dodaj 2–20 graczy lokalnych. Kolejność tur według tej listy."
	},
	"setup_players": {
		Language.ENGLISH: "Players: %d / %d",
		Language.UKRAINIAN: "Гравців: %d / %d",
		Language.POLISH: "Gracze: %d / %d"
	},
	"setup_add_player": {
		Language.ENGLISH: "+ ADD PLAYER",
		Language.UKRAINIAN: "+ ДОДАТИ ГРАВЦЯ",
		Language.POLISH: "+ DODAJ GRACZA"
	},
	"setup_back": {
		Language.ENGLISH: "BACK",
		Language.UKRAINIAN: "НАЗАД",
		Language.POLISH: "POWRÓT"
	},
	"setup_start": {
		Language.ENGLISH: "START GAME",
		Language.UKRAINIAN: "ПОЧАТИ ГРУ",
		Language.POLISH: "ROZPOCZNIJ GRĘ"
	},
	"setup_remove": {
		Language.ENGLISH: "REMOVE",
		Language.UKRAINIAN: "ВИДАЛИТИ",
		Language.POLISH: "USUŃ"
	},
	"setup_error_min": {
		Language.ENGLISH: "At least 2 players are required.",
		Language.UKRAINIAN: "Потрібно мінімум 2 гравців.",
		Language.POLISH: "Wymaganych jest minimum 2 graczy."
	},
	"setup_error_range": {
		Language.ENGLISH: "Choose between 2 and 20 players.",
		Language.UKRAINIAN: "Оберіть від 2 до 20 гравців.",
		Language.POLISH: "Wybierz od 2 do 20 graczy."
	},
	"setup_placeholder": {
		Language.ENGLISH: "Player %d",
		Language.UKRAINIAN: "Гравець %d",
		Language.POLISH: "Gracz %d"
	},
	"game_title": {
		Language.ENGLISH: "UKRAINE × POLAND",
		Language.UKRAINIAN: "УКРАЇНА × ПОЛЬЩА",
		Language.POLISH: "UKRAINA × POLSKA"
	},
	"game_subtitle": {
		Language.ENGLISH: "A friendly cultural exchange",
		Language.UKRAINIAN: "Дружній культурний обмін",
		Language.POLISH: "Przyjazna wymiana kulturowa"
	},
	"game_board_title": {
		Language.ENGLISH: "THE EXCHANGE TRAIL",
		Language.UKRAINIAN: "ШЛЯХ ОБМІНУ",
		Language.POLISH: "ŚCIEŻKA WYMIANY"
	},
	"game_turn": {
		Language.ENGLISH: "PLAYER %d TURN\n%s %s",
		Language.UKRAINIAN: "ХІД ГРАВЦЯ %d\n%s %s",
		Language.POLISH: "TURA GRACZA %d\n%s %s"
	},
	"game_positions": {
		Language.ENGLISH: "PLAYER POSITIONS",
		Language.UKRAINIAN: "ПОЗИЦІЇ ГРАВЦІВ",
		Language.POLISH: "POZYCJE GRACZY"
	},
	"game_position": {
		Language.ENGLISH: "Position: %d",
		Language.UKRAINIAN: "Позиція: %d",
		Language.POLISH: "Pozycja: %d"
	},
	"game_roll": {
		Language.ENGLISH: "ROLL DICE",
		Language.UKRAINIAN: "КИНУТИ КУБИК",
		Language.POLISH: "RZUĆ KOSTKĄ"
	},
	"game_hint": {
		Language.ENGLISH: "Answer a question when you land.\nCorrect answers have no penalty — keep learning!",
		Language.UKRAINIAN: "Відповідайте на питання, коли приземлитесь.\nПравильні відповіді без штрафу — продовжуйте вчитися!",
		Language.POLISH: "Odpowiedz na pytanie, gdy wyllądujesz.\nPoprawne odpowiedzi bez kary — ucz się dalej!"
	},
	"game_start": {
		Language.ENGLISH: "START",
		Language.UKRAINIAN: "СТАРТ",
		Language.POLISH: "START"
	},
	"game_finish": {
		Language.ENGLISH: "FINISH",
		Language.UKRAINIAN: "ФІНІШ",
		Language.POLISH: "META"
	},
	"question_about": {
		Language.ENGLISH: "About %s",
		Language.UKRAINIAN: "Про %s",
		Language.POLISH: "O %s"
	},
	"question_discuss": {
		Language.ENGLISH: "Discuss your answer together, then press DONE.",
		Language.UKRAINIAN: "Обговоріть відповідь разом, потім натисніть ГОТОВО.",
		Language.POLISH: "Omówcie odpowiedź razem, potem naciśnijcie GOTOWE."
	},
	"question_done": {
		Language.ENGLISH: "DONE",
		Language.UKRAINIAN: "ГОТОВО",
		Language.POLISH: "GOTOWE"
	},
	"question_correct": {
		Language.ENGLISH: "✓ Correct! Great job.",
		Language.UKRAINIAN: "✓ Правильно! Чудова робота.",
		Language.POLISH: "✓ Prawidłowo! Świetna robota."
	},
	"question_wrong": {
		Language.ENGLISH: "✗ Not quite. Correct answer: %s",
		Language.UKRAINIAN: "✗ Не зовсім. Правильна відповідь: %s",
		Language.POLISH: "✗ Niezupełnie. Poprawna odpowiedź: %s"
	},
	"question_nice": {
		Language.ENGLISH: "✓ Nice exchange!",
		Language.UKRAINIAN: "✓ Чудовий обмін!",
		Language.POLISH: "✓ Świetna wymiana!"
	},
	"question_continue": {
		Language.ENGLISH: "CONTINUE",
		Language.UKRAINIAN: "ПРОДОВЖИТИ",
		Language.POLISH: "KONTYNUUJ"
	},
	"victory_title": {
		Language.ENGLISH: "🎉  PLAYER WINS!",
		Language.UKRAINIAN: "🎉  ГРАВЕЦЬ ВИГРАВ!",
		Language.POLISH: "🎉  GRACZ WYGRYWA!"
	},
	"victory_reached": {
		Language.ENGLISH: "reached the finish first!",
		Language.UKRAINIAN: "першим досяг фінішу!",
		Language.POLISH: "dotarł do mety jako pierwszy!"
	},
	"victory_learned": {
		Language.ENGLISH: "You learned something about each other's countries!",
		Language.UKRAINIAN: "Ви дізналися щось про країни один одного!",
		Language.POLISH: "Dowiedzieliście się czegoś o krajach siebie nawzajem!"
	},
	"victory_play_again": {
		Language.ENGLISH: "PLAY AGAIN",
		Language.UKRAINIAN: "ГРАТИ ЗНОВУ",
		Language.POLISH: "ZAGRAJ PONOWNIE"
	},
	"victory_menu": {
		Language.ENGLISH: "MAIN MENU",
		Language.UKRAINIAN: "ГОЛОВНЕ МЕНЮ",
		Language.POLISH: "MENU GŁÓWNE"
	},
	"settings_title": {
		Language.ENGLISH: "SETTINGS",
		Language.UKRAINIAN: "НАЛАШТУВАННЯ",
		Language.POLISH: "USTAWIENIA"
	},
	"settings_language": {
		Language.ENGLISH: "Language",
		Language.UKRAINIAN: "Мова",
		Language.POLISH: "Język"
	},
	"settings_resolution": {
		Language.ENGLISH: "Resolution",
		Language.UKRAINIAN: "Роздільна здатність",
		Language.POLISH: "Rozdzielczość"
	},
	"settings_fullscreen": {
		Language.ENGLISH: "Fullscreen",
		Language.UKRAINIAN: "Повноекранний режим",
		Language.POLISH: "Pełny ekran"
	},
	"settings_apply": {
		Language.ENGLISH: "APPLY",
		Language.UKRAINIAN: "ЗАСТОСУВАТИ",
		Language.POLISH: "ZASTOSUJ"
	},
	"country_ukraine": {
		Language.ENGLISH: "Ukraine",
		Language.UKRAINIAN: "Україна",
		Language.POLISH: "Ukraina"
	},
	"country_poland": {
		Language.ENGLISH: "Poland",
		Language.UKRAINIAN: "Польща",
		Language.POLISH: "Polska"
	}
}

func t(key: String, args: Array = []) -> String:
	if not translations.has(key):
		return key

	var text: String = translations[key].get(current_language, key)

	if args.is_empty():
		return text

	# Format string with arguments
	if args.size() == 1:
		return text % args[0]
	else:
		return text % args

func set_language(lang: Language) -> void:
	current_language = lang
	save_settings()

func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("settings", "language", current_language)
	config.save("user://settings.cfg")

func load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load("user://settings.cfg")
	if err == OK:
		current_language = config.get_value("settings", "language", Language.ENGLISH)
