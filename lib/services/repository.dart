

import 'package:quizapp/services/semModel.dart';

class Repository {
  // http://locationsng-api.herokuapp.com/api/v1/lgas
  // test() => _nigeria.map((map) => StateModel.fromJson(map));
  List<Map> getAllcse() => _cse;

  getLocalBySemesterscse(String sem) => _cse
      .map((map) => SemModel.fromJson(map))
      .where((item) => item.sem == sem)
      .map((item) => item.subs)
      .expand((i) => i)
      .toList();
  // _nigeria.where((list) => list['state'] == state);
  // .map((item) => item['lgas'])
  // .expand((i) => i)
  // .toList();

  List<String> getSemesterscse() => _cse
      .map((map) => SemModel.fromJson(map))
      .map((item) => item.sem)
      .toList();
  // _nigeria.map((item) => item['state'].toString()).toList();
 List _cse=[
   {
      "sem": "1 & 2",
      "subs": [
        "Engineering Mechanics",
        "Engineering Graphics",
        "Engineering Chemistry",
        "Engineering Physics",
        "Calculus",
        "Differential Equation",
        "Basics of Electronics Engineering",
        "Basics of Electrical Engineering",
        "Basics of Civil Engineering",
        "Basics of Mechanical Engineering",
        "Intro.To Computing and problem soliving",
        "Introduction To Sustainable Engineering",
        "Introduction To Mechanical Engineering",
        "Introduction To Civil Engineering",
        "Introduction To Electronics Engineering",
        "Introduction To Electrical Engineering",
        "Design and Engineering",
        "computer Programming"
      ]
    },
    {
      "sem": "3",
      "subs": [
        "Discrete Computational Structures",
        "Switching Theory and Logic Design",
        " Data Structures",
        "Electronics Devices & Circuits",
        "Complex Analysis and Linear Algebra",
        "Business Economics",
        "Life Skills"
      ]
    },
    {
      "sem": "4",
      "subs": [
        "Computer Organization and Architecture",
        "Operating Systems",
        "Oriented Design and Programming",
        "Principles of Database Design",
        "Probability Distribution,Transforms and Numerical Methods",
        "Business Economics",
        "Life Skills"
      ]
    },
    {
      "sem": "5",
      "subs": [
         "Theory of Computation",
         "System Software",
         "Microprocessors and Microcontrollers",
         "Data Communication",
         "Graph Theory",
         "Soft computing",
         "Signals and Systems",
         "Digital System Testing & Testable Design",
         "OPTIMIZATION TECHNIQUES",
         "Logic for Computer Science"
      ]
    },
    {
      "sem": "6",
      "subs": [
        "Design and Analysis of Algorithms",
        "Compiler Design",
        "Computer Networks",
        "Software Engineering and Project Management",
        "Principles of Management",
        "Computer Vision",
        "Mobile Computing",
        "Natural Language Processing",
        "Web Technologies",
        "High Performance Computing"
      ]
    }
   ];
  List<Map> getAllce() => _ce;

  getLocalBySemestersce(String sem) => _ce
      .map((map) => SemModel.fromJson(map))
      .where((item) => item.sem == sem)
      .map((item) => item.subs)
      .expand((i) => i)
      .toList();
  // _nigeria.where((list) => list['state'] == state);
  // .map((item) => item['lgas'])
  // .expand((i) => i)
  // .toList();

  List<String> getSemestersce() => _ce
      .map((map) => SemModel.fromJson(map))
      .map((item) => item.sem)
      .toList();
  // _nigeria.map((item) => item['state'].toString()).toList();
  List _ce=[
    {
      "sem": "1 & 2",
      "subs": [
        "Engineering Mechanics",
        "Engineering Graphics",
        "Engineering Chemistry",
        "Engineering Physics",
        "Calculus",
        "Differential Equation",
        "Basics of Electronics Engineering",
        "Basics of Electrical Engineering",
        "Basics of Civil Engineering",
        "Basics of Mechanical Engineering",
        "Intro.To Computing and problem soliving",
        "Introduction To Sustainable Engineering",
        "Introduction To Mechanical Engineering",
        "Introduction To Civil Engineering",
        "Introduction To Electronics Engineering",
        "Introduction To Electrical Engineering",
        "Design and Engineering",
        "computer Programming"
      ]
    },
    {
      "sem": "3",
      "subs": [
        "Engineering Geology",
        "Surveying",
        "Fluid Mechanics I",
        "Mechanics of Solids",
        "Linear Algebra and Complex Analysis",
        "Business Economics",
        "Life skills"
      ]
    },
    {
      "sem": "4",
      "subs": [
        "Construction Technology",
        "Fluid Mechanics II",
        "Geo technical Engineering I"
        "Structural Analysis I",
        "Probability Distribution and Numerical Methods",
        "Business Economics",
        "Life Skills"
      ]
    },
    {
      "sem": "5",
      "subs": [
        "Design of concrete structures I",
        "Structural analysis - II",
        "Geotechnical engineering - II",
        "Geomatics",
        "Water resources engineering",
        "PRINCIPLES OF MANAGEMENT",
        "Advanced concrete technology",
        "Geotechnical investigation",
        "Functional design of buildings",
        "Water conveyance systems",
        "Disaster management",
        "Environment and pollution",
        "Advanced mechanics of materials"
      ]
    },
    {
      "sem": "6",
      "subs": [
        "Design of hydraulic structures"
        "Design of concrete structures - II"
        "Computer programming and computational techniques"
        "Transportation engineering - I"
        "PRINCIPLES OF MANAGEMENT"
        "Ground improvement techniques"
        "Advanced foundation engineering"
        "Traffic engineering and management"
        "Prestressed concrete"
        "Engineering hydrology"
        "Air quality management"
      ]
    }
  ];
}