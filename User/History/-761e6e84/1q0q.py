
transactions = []
balance = 0

def deposite(amount):
    global balance, transactions
    transactions.append(["D", amount])
    balance+=int(amount)

def withdraw(amount):
    global balance, transactions
    transactions.append(["W", amount])
    balance-=int(amount)

while True:
    print("Enter the transaction details: ")
    t1 = input()
    if t1 == "exit" or t1 == "Exit":
        print(transactions)
        print("Balance:", balance)
        break
    t1 = t1.split()
    # transactions.append(t1)
    if t1[0].upper()=="W":
        withdraw(t1[1])
        # balance-=int(t1[1])
    elif t1[0].upper()=="D":
        deposite(t1[1])
        # balance+=int(t1[1])

    print("Balance:", balance)
