CPATH=".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar"

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [[ -f student-submission/ListExamples.java ]]
then
    echo "file found"
else
    echo "file not found"
    exit
fi

cp student-submission/ListExamples.java TestListExamples.java grading-area
cp -r lib grading-area

cd grading-area
javac -cp $CPATH *.java
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

if [[ $? -eq 0 ]]
then
    echo "Compilation successful"
else
    echo "Compilation unsucessful"
fi

#java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt
lastline=$(cat junit-output.txt | tail -n 3)
# | head -n 1
echo $lastline
testAndFailure=$(echo $lastline | grep -oP '\d+'|awk -F'[, ]' '{print $1}')
#echo $testAndFailure
tests=$(echo $testAndFailure | awk '{print $1}')
failures=$(echo $testAndFailure | awk '{print $2}')
tests= ${testAndFailure:0:1}
failures=${testAndFailure:1:2}
#tests=$(echo $lastline | awk -F'[ ]' '{print $3}')
#failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
successes=$((tests - failures))

echo "Your score is $successes / $tests"