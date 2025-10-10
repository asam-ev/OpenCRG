import os

if __name__ == "__main__":
    path = os.getcwd()
    print("create file")
    readme = open(os.getcwd()+"\\README.txt", "w+")
    header = ["/**********************************************************************************",
              " ***  ASAM OpenCRG                                                            ***",
              " ***  Version : 1.2.0                                                           ***",
              " ***  Date:  November 18, 2020                                                     ***",
              " **********************************************************************************/"
              "\n",
              "the deliverables of ASAM OpenCRG 1.2 include:\n"]
    
    for line in header:
        readme.write(line + "\n")

    folders = os.listdir()
    print ("Initial List: "+ str(folders))

    pop_ele = []
    for folder in folders:
        print("\t\t\t\t" + str(folder))
        if folder.find('py') != -1 or folder.find('.git') != -1 or folder.rfind('md') != -1 or folder.rfind('html') != -1:
            print("pop the following Element: \t" +str(folder))
            pop_ele.append(folder)

    print("------------------------------------------------------")
    print(pop_ele)
    print("------------------------------------------------------")
    for ele in pop_ele:
        print("pop the following Element: \t" +str(ele))
        folders.pop(folders.index(ele))
    print ("Final List: "+ str(folders))

    for folder in folders:
        files = os.listdir(path + "\\" + folder)
        readme.write("- " + folder +"\n")
        
        if folder.find("UML_Model_HTML") == -1:
            for file in files:
                readme.write("\t +" + file+"\n")
            readme.write("\n")
        
        else:
            readme.write("\n")



    readme.close()
    print("done writing file")