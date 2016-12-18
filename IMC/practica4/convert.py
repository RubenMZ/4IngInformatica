listOfWrong  = [9, 21, 58, 73, 147, 328, 407, 526, 560, 842, 881]

list = {}
spam = {}
infile = open('BasesDatos/libsvm/test_spam.libsvm', 'r')
for i in listOfWrong:
    list[i] = []
    spam[i] = False

for i, line in enumerate(infile):
    if (i in listOfWrong):
        line = line.split(' ')
        if (int(float(line[0])) == 0):
            spam[i] = False
        else:
            spam[i] = True
        for j in range(1, len(line)):
            list[i].append(int(line[j].split(':')[0]))

infile.close()

infile = open('etiquetasYVocabulario/vocab.txt', 'r')
words = []
words.append('----------')
for i, line in enumerate(infile):
    words.append(line.split('\t')[1].split('\n')[0])
infile.close()

for i in listOfWrong:
    for j, posOfWord in enumerate(list[i]):
        list[i][j] = words[posOfWord]

for i in listOfWrong:
    palabrasAparecidas = ""
    if (spam[i]):
        print "[SPAM] En el correo %d aparecen las siguientes palabras: " %(i)
    else:
        print "[NO SPAM] En el correo %d aparecen las siguientes palabras: " %(i)
    for j in range(len(list[i])):

        palabrasAparecidas += list[i][j] + ", "
    print palabrasAparecidas[:-2] + "."
