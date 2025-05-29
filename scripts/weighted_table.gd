class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum = 0


func add_item(item, weight: int):
	items.append({"item": item, "weight": weight})
	weight_sum += weight
# 批量添加
#func add_items(items: Array, weights: Array):
	#for i in range(items.size()):
		#add_item(items[i], weights[i])



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
	# 在生成随机数前检查有效权重
	if adjusted_weight_sum <= 0:
		return null
	# 如果有排除列表，创建新的考虑列表
	if exclude.size() > 0:
		adjusted_items = [] # 重置考虑的物品列表
		adjusted_weight_sum = 0 # 重置权重总和
		for item in items:
			# 跳过在排除列表中的物品
			if item["item"] in exclude:
				continue # 跳过当前循环继续下一个循环
			adjusted_items.append(item) # 添加非排除物品到新列表
			adjusted_weight_sum += item["weight"] # 累加非排除物品的权重
	
	# 生成一个随机权重值（范围：1到调整后的权重总和）
	var chosen_weight = randi_range(1, adjusted_weight_sum)
	var iteration_sum = 0 # 用于累加权重的临时变量
	
	# 遍历所有考虑的物品
	for item in adjusted_items:
		iteration_sum += item["weight"] # 累加当前物品的权重
		# 当累加值达到或超过随机权重值时，选择当前物品
		if chosen_weight <= iteration_sum:
			return item["item"] # 返回物品本身（而不是包含权重的字典）
