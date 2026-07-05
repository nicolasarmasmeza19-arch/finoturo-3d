extends Node
## Gestor del sistema económico del juego.
## Controla dinero, cuenta bancaria, inversiones e historial financiero.

class_name EconomyManager

# Variables de dinero
var current_cash: float = 100.0
var bank_balance: float = 0.0
var total_debt: float = 0.0

# Configuración bancaria
var interest_rate: float = 0.02  # 2% mensual
var debt_interest_rate: float = 0.05  # 5% mensual

# Historial financiero
var monthly_income: float = 0.0
var monthly_expenses: float = 0.0
var transaction_history: Array = []

# Presupuesto mensual
var monthly_budget: Dictionary = {
	"food": 200.0,
	"transportation": 50.0,
	"entertainment": 100.0,
	"utilities": 150.0,
	"savings": 100.0,
	"investment": 50.0
}

func _ready() -> void:
	print("[EconomyManager] Sistema económico inicializado. Dinero inicial: $%.2f" % current_cash)


## Añade dinero en efectivo
func add_cash(amount: float) -> void:
	if amount <= 0:
		push_error("[EconomyManager] No se puede añadir cantidad negativa")
		return
	
	current_cash += amount
	record_transaction("Ingreso", amount, "income")
	monthly_income += amount
	print("[EconomyManager] +$%.2f. Total en efectivo: $%.2f" % [amount, current_cash])


## Resta dinero en efectivo
func remove_cash(amount: float) -> bool:
	if amount <= 0:
		push_error("[EconomyManager] No se puede restar cantidad negativa")
		return false
	
	if current_cash < amount:
		print("[EconomyManager] Dinero insuficiente. Disponible: $%.2f, Requerido: $%.2f" % [current_cash, amount])
		return false
	
	current_cash -= amount
	record_transaction("Gasto", amount, "expense")
	monthly_expenses += amount
	print("[EconomyManager] -$%.2f. Dinero restante: $%.2f" % [amount, current_cash])
	return true


## Obtiene el dinero en efectivo actual
func get_cash() -> float:
	return current_cash


## Obtiene el balance en el banco
func get_bank_balance() -> float:
	return bank_balance


## Obtiene el dinero total (efectivo + banco)
func get_total_money() -> float:
	return current_cash + bank_balance


## Deposita dinero en el banco
func deposit_to_bank(amount: float) -> bool:
	if not remove_cash(amount):
		return false
	
	bank_balance += amount
	record_transaction("Depósito Bancario", amount, "deposit")
	print("[EconomyManager] Depositado $%.2f en el banco. Balance: $%.2f" % [amount, bank_balance])
	return true


## Retira dinero del banco
func withdraw_from_bank(amount: float) -> bool:
	if amount < 10.0 or amount > 5000.0:
		print("[EconomyManager] Cantidad inválida. Rango: $10.00 - $5000.00")
		return false
	
	if bank_balance < amount:
		print("[EconomyManager] Balance insuficiente en el banco")
		return false
	
	bank_balance -= amount
	current_cash += amount
	record_transaction("Retiro Bancario", amount, "withdrawal")
	print("[EconomyManager] Retirado $%.2f del banco. Nuevo balance: $%.2f" % [amount, bank_balance])
	return true


## Aplica intereses bancarios mensuales
func apply_monthly_interest() -> void:
	var interest: float = bank_balance * interest_rate
	bank_balance += interest
	record_transaction("Intereses Bancarios", interest, "interest")
	print("[EconomyManager] Interés aplicado: +$%.2f" % interest)


## Obtiene la deuda actual
func get_debt() -> float:
	return total_debt


## Solicita un préstamo
func take_loan(amount: float) -> void:
	add_cash(amount)
	total_debt += amount
	record_transaction("Préstamo", amount, "loan")
	print("[EconomyManager] Préstamo de $%.2f. Deuda total: $%.2f" % [amount, total_debt])


## Paga una deuda
func pay_debt(amount: float) -> bool:
	if not remove_cash(amount):
		return false
	
	total_debt = max(0, total_debt - amount)
	record_transaction("Pago de Deuda", amount, "debt_payment")
	print("[EconomyManager] Deuda pagada: $%.2f. Deuda restante: $%.2f" % [amount, total_debt])
	return true


## Obtiene el ingreso mensual
func get_monthly_income() -> float:
	return monthly_income


## Obtiene los gastos mensuales
func get_monthly_expenses() -> float:
	return monthly_expenses


## Obtiene el balance mensual
func get_monthly_balance() -> float:
	return monthly_income - monthly_expenses


## Registra una transacción
func record_transaction(description: String, amount: float, transaction_type: String) -> void:
	var transaction: Dictionary = {
		"description": description,
		"amount": amount,
		"type": transaction_type,
		"date": Time.get_ticks_msec()
	}
	transaction_history.append(transaction)


## Obtiene el historial de transacciones
func get_transaction_history() -> Array:
	return transaction_history


## Obtiene el presupuesto mensual
func get_monthly_budget() -> Dictionary:
	return monthly_budget


## Obtiene un resumen financiero
func get_financial_summary() -> Dictionary:
	return {
		"cash": current_cash,
		"bank_balance": bank_balance,
		"total_money": get_total_money(),
		"debt": total_debt,
		"monthly_income": monthly_income,
		"monthly_expenses": monthly_expenses,
		"monthly_balance": get_monthly_balance()
	}
