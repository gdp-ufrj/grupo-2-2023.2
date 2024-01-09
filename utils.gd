extends Node

func findByClass(node: Node, className : String, result : Array = []) -> Array:	
		if node.has_method("get_class_name"):
			if node.get_class_name() == className:
				result.push_back(node)
		for child in node.get_children():
			findByClass(child, className, result)
		return result
