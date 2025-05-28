class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum = 0


func add_item(item, weight: int):
	items.append({"item": item, "weight": weight})
	weight_sum += weight


func remove_item(item_to_remove):
	# 检查数组里的物品是否等于要被移除的物品，如果不是该物品通过
	items = items.filter(func (item): return item["item"] != item_to_remove)
	# 重新计算数组权重
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]


func pick_item(exclude: Array = []):
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0
		for item in items:
			if item["item"] in exclude:
				continue # 跳过当前循环继续下一个循环
			adjusted_items.append(item) # 加入数组
			adjusted_weight_sum += item["weight"] # 加入总权重
	
	var chosen_weight = randi_range(1, adjusted_weight_sum) # 挑选权重
	var iteration_sum = 0
	for item in adjusted_items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			return item["item"]
