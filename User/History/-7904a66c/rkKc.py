
marks = []

total = 0
absent = 0
print("enter the number of students: ")
students_no = int(input())
for i in range(students_no):
    print(f"Enter the score of student {i+1}: (type A for absent students)")
    mark = input()
    if mark == "A" or mark == "a":
        marks.append("A")
        absent += 1
    else:
        marks.append(int(mark))
        total += int(mark)

median=0
for i in marks:
    temp = 0
    for j in marks:
        if i == j:
            temp+=1


print(f"Average score of class: {total/students_no}")
print(f"Maximum score: {max(marks)}")
print(f"Number of students absent: {absent}")
# print(f"highest frequency of marks: {}")

