#include <iostream>
#include <vector>
#include<string>
using namespace std;

class Person {
protected:
    string name;
    int ID;
    int Age;

public:
    Person() {
        name = "";
        ID = 0;
        Age = 0;
    }
    Person(int ID, string name, int Age) {
        this->ID = ID;
        this->name = name;
        this->Age = Age;
    }

    virtual ~Person() {}

    string get_name() { return name; }
    int get_ID() { return ID; }
    int get_Age() { return Age; }

    virtual string getDetails() = 0;
    void set_name(string s) {
        name = s;
    }
};

class Course {
    string code;
    string name;

public:
    Course(string code, string name) {
        this->code = code;
        this->name = name;
    }

    string get_name() { return name; }
    string get_code() { return code; }
};

class Student : public Person {
    int level;
    vector<Course*> courses;

public:
    Student(int ID, string name, int Age, int level) : Person(ID, name, Age) {
        this->level = level;
    }

    void enroll(Course* c) {
        courses.push_back(c);
    }
    //getters
    vector<Course*> get_courses() {
        return courses;
    }

    int get_level() { return level; }
    //setter 
    void set_level(int l) {
        level = l;
    }


    string getDetails() override {
        string result = "Student Info:\n";
        result += "Name: " + name + "\n";
        result += "ID: " + to_string(ID) + "\n";
        result += "Age: " + to_string(Age) + "\n";
        result += "Level: " + to_string(level) + "\n";
        result += "Courses:\n";

        for (int i = 0; i < courses.size(); i++) {
            result += "- " + courses[i]->get_name() + "\n";
        }

        return result;
    }
};

class Doctor : public Person {
    string title;
    vector<Course*> courses;

public:
    Doctor(int ID, string name, int Age, string title) : Person(ID, name, Age) {
        this->title = title;
    }

    void teach(Course* c) {
        courses.push_back(c);
    }
    //getters
    vector<Course*> get_courses() {
        return courses;
    }

    string get_title() { return title; }

    
    string getDetails() override {
        string result = "Doctor Info:\n";
        result += "Name: " + name + "\n";
        result += "ID: " + to_string(ID) + "\n";
        result += "Age: " + to_string(Age) + "\n";
        result += "Title: " + title +"\n";
        result += "Courses:\n";

        for (int i = 0; i < courses.size(); i++) {
            result += "- " + courses[i]->get_name() + "\n";
        }

        return result;
    }
    //setter
    void set_title(string t) {
        title = t;
    }

};

class Department {
    string name;
    vector<Student*> students;
    vector<Doctor*> doctors;
    vector<Course*> courses;

public:
    Department(string name) {
        this->name = name;
    }

    void add_student(Student* s) {
        students.push_back(s);
    }

    void add_doctor(Doctor* d) {
        doctors.push_back(d);
    }

    void add_course(Course* c) {
        courses.push_back(c);
    }

    string getDetails() {
        string result = "Department: " + name + "\n";
        result += "Students:\n";
        for (int i = 0; i < students.size(); i++) {
            result += "- " + students[i]->get_name() + "\n";
        }
        result += "Doctors:\n";
        for (int i = 0; i < doctors.size(); i++) {
            result += "- " + doctors[i]->get_name() + "\n";
        }
        result += "Courses:\n";
        for (int i = 0; i < courses.size(); i++) {
            result += "- " + courses[i]->get_name() + "\n";
        }
        return result;
    }
};

class Display {
public:
    void show(Person* p) {
        cout << p->getDetails() << endl;
        cout << "============================" << endl;

    }

    void showDepartment(Department* d) {
        cout << d->getDetails() << endl;
        cout << "============================" << endl;

    }
};




int main() {

    Student s1(1, "Hasnaa", 20, 2);
    Student s2(2, "Habiba", 20, 2);
    Student s3(3, "Ali", 19, 1);

    Course c1("1345F", "Algorithm");
    Course c2("2356F", "Network");

    Doctor d1(2, "Dr-Osama", 45, "Professor");
    Doctor d2(3, "Dr-Mostafa", 50, "Professor");

    Department dept1("Computer Science");
    Department dept2("Information Technology");

    d1.teach(&c1);
    d2.teach(&c2);

    s1.enroll(&c1);
    s2.enroll(&c1);
    s3.enroll(&c2);

    dept1.add_course(&c1);
    dept2.add_course(&c2);

    dept1.add_student(&s1);
    dept1.add_student(&s2);
    dept1.add_doctor(&d1);

    dept2.add_student(&s3);
    dept2.add_doctor(&d2);

    Display display;

    display.show(&s1);
    display.show(&d1);

    display.showDepartment(&dept1);
    display.showDepartment(&dept2);

    return 0;
}