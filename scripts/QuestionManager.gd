class_name QuestionManager
extends RefCounted

var questions: Array[Dictionary] = []
var used: Dictionary = {}

func _init() -> void:
	questions = [
		q("GEOGRAPHY", "Poland", "What is the capital of Poland?", ["Warsaw", "Krakow", "Gdansk", "Wroclaw"], 0),
		q("GEOGRAPHY", "Ukraine", "What is the capital of Ukraine?", ["Lviv", "Kyiv", "Odesa", "Kharkiv"], 1),
		q("GEOGRAPHY", "Poland", "Which city is famous for its old town and Wawel Castle?", ["Krakow", "Lodz", "Szczecin", "Lublin"], 0),
		q("GEOGRAPHY", "Ukraine", "Which city is known for its beautiful old town in western Ukraine?", ["Lviv", "Dnipro", "Poltava", "Mykolaiv"], 0),
		q("GEOGRAPHY", "Poland", "Which sea is north of Poland?", ["Baltic Sea", "Black Sea", "North Sea", "Adriatic Sea"], 0),
		q("GEOGRAPHY", "Ukraine", "Which sea is south of Ukraine?", ["Black Sea", "Baltic Sea", "Caspian Sea", "Red Sea"], 0),
		q("GEOGRAPHY", "Poland", "Name three cities in Poland.", [], -1, "open"),
		q("GEOGRAPHY", "Ukraine", "Name three cities in Ukraine.", [], -1, "open"),
		q("GEOGRAPHY", "Poland", "Which river flows through Warsaw?", ["Vistula", "Danube", "Dnieper", "Oder"], 0),
		q("GEOGRAPHY", "Ukraine", "Which river flows through Kyiv?", ["Dnieper", "Vistula", "Rhine", "Oder"], 0),
		q("CULTURE", "Poland", "What are the colors of the Polish flag?", ["White and red", "Blue and yellow", "Green and white", "Red and black"], 0),
		q("CULTURE", "Ukraine", "What are the colors of the Ukrainian flag?", ["Blue and yellow", "White and red", "Green and white", "Blue and red"], 0),
		q("CULTURE", "Poland", "Which famous composer was born in Poland?", ["Fryderyk Chopin", "Mozart", "Beethoven", "Vivaldi"], 0),
		q("CULTURE", "Ukraine", "Which famous writer wrote The Forest Song?", ["Lesya Ukrainka", "Adam Mickiewicz", "Taras Shevchenko", "Ivan Franko"], 0),
		q("CULTURE", "Poland", "What is a popular sport in Poland?", ["Football", "Sumo", "Cricket", "Curling"], 0),
		q("CULTURE", "Ukraine", "What is a popular sport in Ukraine?", ["Football", "Baseball only", "Kabaddi", "Cricket"], 0),
		q("CULTURE", "Poland", "Name a traditional Polish holiday or celebration.", [], -1, "open"),
		q("CULTURE", "Ukraine", "Name a traditional Ukrainian holiday or celebration.", [], -1, "open"),
		q("CULTURE", "Poland", "Which building is a landmark in Warsaw?", ["Royal Castle", "Eiffel Tower", "Colosseum", "Acropolis"], 0),
		q("CULTURE", "Ukraine", "Which place is a famous landmark in Kyiv?", ["Saint Sophia Cathedral", "Wawel Castle", "Big Ben", "Brandenburg Gate"], 0),
		q("FOOD", "Poland", "Which dish is traditional Polish food?", ["Pierogi", "Sushi", "Tacos", "Couscous"], 0),
		q("FOOD", "Ukraine", "Which dish is strongly associated with Ukraine?", ["Borscht", "Paella", "Curry", "Sushi"], 0),
		q("FOOD", "Poland", "What is a popular Polish soup?", ["Żurek", "Gazpacho", "Miso", "Pho"], 0),
		q("FOOD", "Ukraine", "What is a popular Ukrainian soup?", ["Borscht", "Miso", "Tom yum", "Chowder"], 0),
		q("FOOD", "Poland", "Which dessert is popular in Poland?", ["Makowiec", "Baklava", "Mochi", "Tiramisu"], 0),
		q("FOOD", "Ukraine", "Which sweet pastry is popular in Ukraine?", ["Pampushky", "Croissant", "Cannoli", "Mochi"], 0),
		q("FOOD", "Poland", "Name a Polish dish you would like to try.", [], -1, "open"),
		q("FOOD", "Ukraine", "Name a Ukrainian dish you would like to try.", [], -1, "open"),
		q("FOOD", "Poland", "Which ingredient is often used in pierogi fillings?", ["Potato", "Coconut", "Pineapple", "Chocolate only"], 0),
		q("FOOD", "Ukraine", "Which ingredient is common in many Ukrainian dishes?", ["Beetroot", "Seaweed only", "Cocoa", "Olives only"], 0),
		q("LANGUAGE", "Poland", "Which Polish word means hello?", ["Cześć", "Dziękuję", "Proszę", "Dobranoc"], 0),
		q("LANGUAGE", "Ukraine", "Which Ukrainian word means hello?", ["Привіт", "Дякую", "Будь ласка", "До побачення"], 0),
		q("LANGUAGE", "Poland", "Which Polish word means thank you?", ["Dziękuję", "Cześć", "Tak", "Dom"], 0),
		q("LANGUAGE", "Ukraine", "Which Ukrainian word means thank you?", ["Дякую", "Привіт", "Так", "Місто"], 0),
		q("LANGUAGE", "Poland", "What does ‘tak’ mean in Polish?", ["Yes", "No", "Hello", "Friend"], 0),
		q("LANGUAGE", "Ukraine", "What does ‘так’ mean in Ukrainian?", ["Yes", "No", "Hello", "Friend"], 0),
		q("LANGUAGE", "Poland", "Say one simple sentence in Polish.", [], -1, "open"),
		q("LANGUAGE", "Ukraine", "Say one simple sentence in Ukrainian.", [], -1, "open"),
		q("LANGUAGE", "Poland", "Name three words in Polish.", [], -1, "open"),
		q("LANGUAGE", "Ukraine", "Name three words in Ukrainian.", [], -1, "open"),
		q("INTERACTION", "Poland", "Name two similarities between Ukrainian and Polish culture.", [], -1, "open"),
		q("INTERACTION", "Ukraine", "Name two similarities between Ukrainian and Polish culture.", [], -1, "open"),
		q("INTERACTION", "Poland", "What place in Poland would you like to visit? Why?", [], -1, "open"),
		q("INTERACTION", "Ukraine", "What place in Ukraine would you like to visit? Why?", [], -1, "open"),
		q("INTERACTION", "Poland", "What would you show a Polish visitor in your country?", [], -1, "open"),
		q("INTERACTION", "Ukraine", "What would you show a Ukrainian visitor in your country?", [], -1, "open"),
		q("INTERACTION", "Poland", "Name three things you know about Poland.", [], -1, "open"),
		q("INTERACTION", "Ukraine", "Name three things you know about Ukraine.", [], -1, "open"),
		q("INTERACTION", "Poland", "Ask your opponent one question about Poland.", [], -1, "open"),
		q("INTERACTION", "Ukraine", "Ask your opponent one question about Ukraine.", [], -1, "open"),
		q("INTERACTION", "Poland", "FINAL TASK: Name five facts you remember about Poland.", [], -1, "open"),
		q("INTERACTION", "Ukraine", "FINAL TASK: Name five facts you remember about Ukraine.", [], -1, "open")
	]

func q(category: String, target: String, prompt: String, answers: Array, correct: int, kind: String = "choice") -> Dictionary:
	return {"category": category, "target": target, "prompt": prompt, "answers": answers, "correct": correct, "type": kind}

func get_question(category: String, target: String) -> Dictionary:
	var candidates: Array[Dictionary] = []
	for item in questions:
		if item.category == category and item.target == target:
			candidates.append(item)
	if candidates.is_empty():
		for item in questions:
			if item.target == target:
				candidates.append(item)
	var key := category + target
	var available := candidates.filter(func(item: Dictionary) -> bool: return not used.has(item.prompt))
	if available.is_empty():
		for item in candidates: used.erase(item.prompt)
		available = candidates
	var chosen: Dictionary = available[randi() % available.size()].duplicate(true)
	used[chosen.prompt] = true
	if chosen.type == "choice":
		var pairs: Array = []
		for i in chosen.answers.size(): pairs.append({"text": chosen.answers[i], "correct": i == chosen.correct})
		pairs.shuffle()
		chosen.answers = pairs.map(func(pair: Dictionary) -> String: return pair.text)
		chosen.correct_text = pairs.filter(func(pair: Dictionary) -> bool: return pair.correct)[0].text
	return chosen
