# library for system functions
import sys 
# library with class for parser imlementation
from gedcom.parser import Parser
# import IndividualElement object from gedcom.element class 
from gedcom.element.individual import IndividualElement

# function for writing to file parsed ged document
def writeToFile(fileName, children, males, females):
    # whereas open file
    with open(fileName, 'w') as fres:
        # write all child's causes to parsed file
        for child in children:
            fres.write(child + '\n')
        # write all male's causes to parsed file
        for male in males:
            fres.write(male + '\n')
        # write all female's causes to parsed file
        for female in females:
            fres.write(female + '\n')

# Adds gender cause 
def genAdd(pers, males, females):
    # assing gender of pers object via get_gender method
    gen = pers.get_gender()

    # there is two cases: Male and Female
    if (gen == "F"):    
        females.append("female(" + nameGet(pers) + ").")
    elif (gen == "M"):
        males.append("male(" + nameGet(pers) + ").")

# retrieve name of the person
def nameGet(pers):
    # assing name of pers object via get_name method
    (first, last) = pers.get_name()
    # if last == empty space => add \''\ symbols
    if (last != ""):
        return "\'" + first + " " + last + "\'"
    return "\'" + first + "\'"
    
def main():
    gparser = Parser() # initialize an object of Parser class
    gparser.parse_file(sys.argv[1], 0) # initialize file to parse
    rootChildElems = gparser.get_root_child_elements() # get root's children

    # create empty lists for three types of causes    
    males     = []
    females   = []
    children  = []

    # main loop for root's children
    for p in rootChildElems:
        # if p is olbject of IndividualElement class 
        if isinstance(p, IndividualElement):
            # add gender cause
            genAdd(p, males, females)
            # if p is child   
            if (p.is_child()):
                # loop for all parents
                for par in gparser.get_parents(p, "ALL"):
                    # add to back cause string 
                    children.append("child(" + nameGet(p) + ", " + nameGet(par) + ").")

    # we need three args: <script>.py <file_to_parse>.ged <parsed_file>.pl 
    if (len(sys.argv) == 3):
        writeToFile(sys.argv[2], children, males, females)
    # exception
    else:
        print("3 argument are required!\n")
    
# run script 
main()
