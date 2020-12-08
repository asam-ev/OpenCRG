import os

TABLE_INT = 1

def read_adoc(path):
    figures = []
    tables = []

    adoc = open(path, "r+" )
    #this try and except Block is to sort out the loading problems with some adoc files
    #will be solved later on.

    lines = adoc.readlines()


    
    for line in lines:
        if line.find("image::") != -1:
            if line.find(".png[img") != -1:
                img_number = line[line.find(".png[img")+len(".png[img"):]
                img_number = img_number[:img_number.find(",")]
            elif line.find(".svg[img") != -1: 
                img_number = line[line.find(".svg[img")+len(".svg[img"):]
                img_number = img_number[:img_number.find(",")]

            if len(img_number) == 1:
                img_number = "00" + img_number
            elif len(img_number) == 2:
                img_number = "0" + img_number


            title = line[line.find("title"):]
            title = title[title.find('"')+1:]
            title = title[:title.rfind('"')]
            figures.append([img_number, title])

        elif line.find(".Deliv") !=-1 or line.find(".Overview") !=-1 or line.find(".Rules") !=-1 or line.find(".Typo") !=-1 or line.find(".Road") !=-1 or line.find(".Map") !=-1  or line.find(".Data") !=-1  or line.find(".Option") !=-1 or line.find(".Modi") !=-1 or line.find(".File") !=-1 or line.find(".Eval") !=-1 or line.find(".Visu") !=-1 or line.find(".Check") !=-1 or line.find(".Gen") !=-1 or line.find(".Geo") !=-1 :
            tables.append(line[1:])


    return figures, tables

def write_list_figures(adoc_figures, array_figures):
    print(adoc_figures)
    print(array_figures)
    array_figures.sort()
    content = ["== List of figures",
               "\n",
               '[cols="10,80, 10", grid=none, frame=none]',
               "|==="]
    for figure in array_figures:
        fig = "|Figure "+ str(int(figure[0])) + ": |" + figure[1] + "|" #<<img" + figure[0] +">>"
        content.append(fig)
    
    content.append("|===")

    for line in content:
        adoc_figures.write(line + "\n")

    adoc_figures.close

def write_list_tables(adoc_tables, array_tables):
    content = ["== List of tables",
               "\n",
               '[cols="10,90", grid=none, frame=none]',
               "|==="]

    for table in array_tables:
        table = "|Table "+ str(array_tables.index(table)+1) + ": |" + table
        content.append(table)
   
    content.append("|===")

    for line in content:
        adoc_tables.write(line + "\n")

    adoc_tables.close




if __name__ == "__main__":
    TABLE_INT = 1

    path = os.getcwd() + "\\documents\\specification"
    
    chapters = os.listdir(path)
    chapters.sort()

    #chapters.append(chapters.pop(1)) # move chapter 10 to the End
    #chapters.append(chapters.pop(1)) # move chapter 11 to the End
    #chapters.append(chapters.pop(1)) # move chapter 12 to the End
    #chapters.pop(0)

    array_figures = []
    array_tables = []

    list_adoc_files = []
    #run through all the chapter folders and find the adoc files
    for chapter in chapters:
        if chapter.find(".") == -1:
            chapter_path = path +"\\" + chapter
            temp_list = os.listdir(chapter_path)
            for ele in temp_list:
                if ele.find(".adoc") != -1:
                    list_adoc_files.append(chapter_path + "\\" + ele)

    for adoc in list_adoc_files:
        tmp_figures, tmp_tables = read_adoc(adoc)
        array_figures = array_figures + tmp_figures
        array_tables = array_tables + tmp_tables
    
    adoc_tables = open(path+"\\6_list_of_tables.adoc", "w")
    write_list_tables(adoc_tables,array_tables)
    adoc_figures = open(path+"\\7_list_of_figures.adoc", "w")
    write_list_figures(adoc_figures,array_figures)