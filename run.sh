PAR=$1
chapter=`echo $PAR | cut -d'.' -f1`
program=`echo $PAR | cut -d'.' -f2`
cdir=chapter$chapter/$program	
# Declare colors
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' 
# Print errors in red
printError () {
	echo -e "\n${RED}===> $@${NC}\n"
}
# Print with colors
print () {
	echo -e "\n${BLUE}===> $@${NC}\n"
}
if [[ $1 = exercise* ]]; then
	chapter=`echo $PAR | cut -d'.' -f2`
	program=`echo $PAR | cut -d'.' -f3`
	cdir=chapter$chapter/exercises/$program
fi
if [ -f "$cdir/main.c" ]; then
	print Compiling program $program from chapter $chapter 
	cd $cdir
	gcc main.c -o ../../main
	if [ $? != 0 ]; then
		printError "Error while compiling $cdir/main.c"
		exit 1
	fi
	cd ../../
	file main
	print Running program..
	./main
	if [ $? != 0 ]; then
		printError "Error while running the program"
	else
		print "Program has executed successfully"
	fi
	print Cleaning up..
	rm main
else
	echo Invalid option, the options are..
	for chapter in chapter*; do
		bdir=`pwd`
		cd $chapter
		for program in *; do
			if [ $program != *exercises* ]; then
				echo $chapter.$program | sed "s/chapter//g"
			else
				cd exercises
				for program in *; do
					echo exercise.$chapter.$program | sed "s/chapter//g"
				done
			fi
		done
		cd $bdir
	done		
fi

