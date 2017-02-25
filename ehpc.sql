-- MySQL dump 10.13  Distrib 5.6.22, for osx10.9 (x86_64)
--
-- Host: localhost    Database: ehpc
-- ------------------------------------------------------
-- Server version	5.6.22

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('f215904daceb');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apply`
--

DROP TABLE IF EXISTS `apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `apply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `course_id` int(11) NOT NULL DEFAULT '0',
  `status` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `apply_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `apply_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apply`
--

LOCK TABLES `apply` WRITE;
/*!40000 ALTER TABLE `apply` DISABLE KEYS */;
INSERT INTO `apply` VALUES (1,3,1,1),(2,3,4,0),(3,2,4,0),(4,3,6,0),(5,2,1,0);
/*!40000 ALTER TABLE `apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `content` text NOT NULL,
  `visitNum` int(11) DEFAULT NULL,
  `updatedTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
INSERT INTO `articles` VALUES (4,'并行编程入门','本内容以并行计算为主题，由并行结构、并行算法、并行编程及并行算法实例四部分内容构成，强调并行结构、并行算法、并行程序设计的有机联系，从基础、算法实例、算法分析、算法实现以及应用各个角度介绍了并行计算的基本技术。',14,'2016-12-21 00:00:00'),(6,'C++ 编译过程','简单地说，一个编译器就是一个程序，它可以阅读以某一种语言（源语言）编写的程序，并把该程序翻译成一个等价的、用另一种语言（目标语言）编写的程序。\r\n\r\nC/C++编译系统将一个程序转化为可执行程序的过程包含：\r\n\r\n* 预处理(preprocessing)：根据已放置的文件中的预处理指令来修改源文件的内容。\r\n* 编译(compilation)：通过词法分析和语法分析，在确认所有指令都是符合语法规则之后，将其翻译成等价的中间代码表示或汇编代码。\r\n* 汇编(assembly)：把汇编语言代码翻译成目标机器指令的过程。\r\n* 链接(linking)：找到所有用到的函数所在的目标文件，并把它们链接在一起合成为可执行文件(executable file)。\r\n\r\n# 预处理\r\n\r\n预处理器是在程序源文件被编译之前根据预处理指令对程序源文件进行处理的程序。**预处理器指令以#号开头标识，末尾不包含分号**。预处理命令不是C/C++语言本身的组成部分，不能直接对它们进行编译和链接。C/C++语言的一个重要功能是可以使用预处理指令和具有预处理的功能。C/C++提供的预处理功能主要有文件包含、宏替换、条件编译等。\r\n\r\n## 文件包含\r\n\r\n预处理指令 #include 用于包含头文件，有两种形式：#include <xxx.h>，#include \"xxx.h\"。\r\n\r\n尖括号形式表示被包含的文件在系统目录中。如果被包含的文件不一定在系统目录中，应该用双引号形式。在双引号形式中可以指出文件路径和文件名。如果在双引号中没有给出绝对路径，则默认为用户当前目录中的文件，此时系统首先在用户当前目录中寻找要包含的文件，若找不到再在系统目录中查找。\r\n\r\n对于用户自己编写的头文件，宜用双引号形式。对于系统提供的头文件，既可以用尖括号形式，也可以用双引号形式，都能找到被包含的文件，但显然用尖括号形式更直截了当，效率更高。\r\n\r\n## 宏替换\r\n\r\n`宏定义`：一般用一个短的名字代表一个长的代码序列。宏定义包括无参数宏定义和带参数宏定义两类。宏名和宏参数所代表的代码序列可以是任何意义的内容，如类型、常量、变量、操作符、表达式、语句、函数、代码块等。\r\n\r\n宏定义在源文件中必须单独另起一行，换行符是宏定义的结束标志，因此宏定义以换行结束，不需要分号等符号作分隔符。如果一个宏定义中代码序列太长，一行不够时，可采用续行的方法。续行是在键入回车符之前先键入符号\\，注意回车要紧接在符号\\之后，中间不能插入其它符号，当然代码序列最后一行结束时不能有\\。\r\n\r\n预处理器在处理宏定义时，会对宏进行展开（即`宏替换`）。宏替换首先将源文件中在宏定义随后所有出现的宏名均用其所代表的代码序列替换之，如果是带参数宏则接着将代码序列中的宏形参名替换为宏实参名。宏替换只作代码字符序列的替换工作，不作任何语法的检查，也不作任何的中间计算，一切其它操作都要在替换完后才能进行。如果宏定义不当，错误要到预处理之后的编译阶段才能发现。\r\n\r\n## 条件编译\r\n\r\n一般情况下，在进行编译时对源程序中的每一行都要编译，但是有时希望程序中某一部分内容只在满足一定条件时才进行编译，如果不满足这个条件，就不编译这部分内容，这就是`条件编译`。\r\n\r\n条件编译主要是进行编译时进行有选择的挑选，注释掉一些指定的代码，以达到多个版本控制、防止对文件重复包含的功能。if, #ifndef, #ifdef, #else, #elif, #endif是比较常见条件编译预处理指令，可根据表达式的值或某个特定宏是否被定义来确定编译条件。\r\n\r\n此外，还有 #pragma 指令，它的作用是设定编译器的状态或指示编译器完成一些特定的动作。\r\n\r\n# 编译\r\n\r\n编译过程的第一个步骤称为词法分析（lexical analysis）或扫描（scanning），词法分析器读入组成源程序的字符流，并且将它们组织成有意义的词素的序列，对于每个词素，词法分析器产生一个词法单元（token），传给下一个步骤：语法分析。\r\n\r\n语法分析（syntax analysis）或解析（parsing）是编译的第二个步骤，使用词法单元来创建树形的中间表示，该中间表示给出了词法分析产生的词法单元流的语法结构。一个常用的表示方法是语法树（syntax tree），树中每个内部结点表示一个运算，而该结点的子结点表示该运算的分量。\r\n\r\n接下来是语义分析（semantic analyzer），使用语法树和符号表中的信息来检测源程序是否和语言定义的语义一致。\r\n\r\n在源程序的语法分析和语义分析之后，生成一个明确的低级的或者类机器语言的中间表示。接下来一般会有一个机器无关的代码优化步骤，试图改进中间代码，以便生成更好的目标代码。\r\n\r\n# 汇编\r\n\r\n对于被翻译系统处理的每一个C/C++语言源程序，都将最终经过这一处理而得到相应的目标文件。目标文件中所存放的也就是与源程序等效的目标机器语言代码。目标文件由段组成，通常一个目标文件中至少有两个段：代码段和数据段。\r\n\r\n* 代码段：该段中所包含的主要是程序的指令。该段一般是可读和可执行的，但一般却不可写。\r\n* 数据段：主要存放程序中要用到的各种全局变量或静态的数据。一般数据段都是可读，可写，可执行的。\r\n\r\n# 链接\r\n\r\n链接程序的主要工作就是将有关的目标文件彼此相连接，也即将在一个文件中引用的符号同该符号在另外一个文件中的定义连接起来，使得所有的这些目标文件成为一个能够按操作系统装入执行的统一整体。主要有静态链接和动态链接两种方式：\r\n\r\n* `静态链接`：在链接阶段，会将汇编生成的目标文件.o与引用到的库一起链接打包到可执行文件中，程序运行的时候不再需要静态库文件。\r\n* `动态链接`：把调用的函数所在文件模块（DLL）和调用函数在文件中的位置等信息链接进目标程序，程序运行的时候再从DLL中寻找相应函数代码，因此需要相应DLL文件的支持。  \r\n\r\n这里的库是写好的现有的，成熟的，可以复用的代码。现实中每个程序都要依赖很多基础的底层库，不可能每个人的代码都从零开始，因此库的存在意义非同寻常。本质上来说库是一种可执行代码的二进制形式，可以被操作系统载入内存执行。库有两种：静态库（.a、.lib）和动态库（.so、.dll），所谓静态、动态是指链接方式的不同。\r\n\r\n静态链接库与动态链接库都是**共享代码**的方式。如果采用静态链接库，程序在运行时与函数库再无瓜葛，移植方便。但是会浪费空间和资源，因为所有相关的目标文件与牵涉到的函数库被链接合成一个可执行文件。此外，静态库对程序的更新、部署和发布也会带来麻烦。如果静态库更新了，所有使用它的应用程序都需要重新编译、发布给用户。\r\n\r\n动态库在程序编译时并不会被连接到目标代码中，而是在程序运行是才被载入。不同的应用程序如果调用相同的库，那么在内存里只需要有一份该共享库的实例，规避了空间浪费问题。动态库在程序运行是才被载入，也解决了静态库对程序的更新、部署和发布页会带来麻烦。用户只需要更新动态库即可，增量更新。\r\n\r\n此外，还要注意静态链接库中不能再包含其他的动态链接库或者静态库，而在动态链接库中还可以再包含其他的动态或静态链接库。\r\n\r\n# 简单的例子\r\n\r\n下面是一个保存在文件 helloworld.cpp 中一个简单的 C++ 程序的代码：\r\n\r\n    /* helloworld.cpp */\r\n    #include <iostream>\r\n    int main(int argc,char *argv[])\r\n    {\r\n        std::cout << \"hello, world\" << std::endl;\r\n        return 0;\r\n    }\r\n\r\n用下面命令编译：\r\n\r\n    $ g++ helloworld.cpp\r\n\r\n编译器 g++ 通过检查命令行中指定的文件的后缀名可识别其为 C++ 源代码文件。编译器默认的动作：编译源代码文件生成对象文件(object file)，链接对象文件和 libstd c++ 库中的函数得到可执行程序，然后删除对象文件。由于命令行中未指定可执行程序的文件名，编译器采用默认的 a.out。\r\n\r\n## 预处理\r\n\r\n选项 -E 使 g++ 将源代码用编译预处理器处理后不再执行其他动作。下面的命令预处理源码文件 helloworld.cpp，并将结果保存在 .ii 文件中：\r\n\r\n    ➜  ~  g++ -E helloworld.cpp -o helloworld.ii\r\n    ➜  ~  ls | grep helloworld\r\n    helloworld.cpp\r\n    helloworld.ii\r\n    ➜  ~  wc -l helloworld.ii\r\n       38126 helloworld.ii\r\n\r\nhelloworld.cpp 的源代码，仅仅有六行，而且该程序除了显示一行文字外什么都不做，但是，预处理后的版本将超过3万行。这主要是因为头文件 iostream 被包含进来，而且它又包含了其他的头文件，除此之外，还有若干个处理输入和输出的类的定义。\r\n\r\n## 编译\r\n\r\n选项 -S 指示编译器将程序编译成汇编代码，输出汇编语言代码而后结束。下面的命令将由 C++ 源码文件生成汇编语言文件 helloworld.s，生成的汇编语言依赖于编译器的目标平台。\r\n\r\n    g++ -S helloworld.cpp\r\n\r\n## 汇编\r\n\r\n选项 -c 用来告诉编译器将汇编代码（.s文件，或者直接对源代码）转换为目标文件，但不要执行链接。输出结果为对象文件，文件默认名与源码文件名相同，只是将其后缀变为 .o。\r\n\r\n    ➜  ~  g++ -c helloworld.s\r\n    ➜  ~  ls |grep helloworld.o\r\n    helloworld.o\r\n\r\n\r\n## 链接\r\n\r\n加载相应的库，执行链接操作，将对象文件（.o，也可以直接将原文件）转化成可执行程序。\r\n\r\n    ➜  ~  g++ helloworld.o -o helloworld.o\r\n    ➜  ~  ./helloworld.o\r\n    hello, world\r\n\r\n\r\n# 更多阅读\r\n  \r\n[详解C/C++预处理器](http://blog.csdn.net/huang_xw/article/details/7648117)  \r\n[Compiling Cpp](http://wiki.ubuntu.org.cn/Compiling_Cpp)  \r\n[C++静态库与动态库](http://www.cnblogs.com/skynet/p/3372855.html)  \r\n[高级语言的编译：链接及装载过程介绍](http://tech.meituan.com/linker.html)    \r\n[编译原理 (预处理>编译>汇编>链接)](http://www.cnblogs.com/pipicfan/archive/2012/07/10/2583910.html)  \r\n\r\n',19,'2016-10-21 00:00:00'),(13,'添加资讯测试','\r\n# 轻松分享\r\n\r\n- 添加协作者，邀请小伙伴来一起协作\r\n- 你可以自行控制文档/表格的协作权限，只读/可写/私有，\r\n- 或协作或私密，由你一手掌控\r\n\r\n![石墨文档](https://assets-cdn.shimo.im/assets/images/home/personal/personal_qsfx-720ce6d09f.png)',15,'2016-10-24 02:55:04');
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `case_code_materials`
--

DROP TABLE IF EXISTS `case_code_materials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `case_code_materials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version_id` int(11) NOT NULL,
  `name` varchar(1024) NOT NULL,
  `uri` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `version_id` (`version_id`),
  CONSTRAINT `case_code_materials_ibfk_1` FOREIGN KEY (`version_id`) REFERENCES `case_versions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `case_code_materials`
--

LOCK TABLES `case_code_materials` WRITE;
/*!40000 ALTER TABLE `case_code_materials` DISABLE KEYS */;
INSERT INTO `case_code_materials` VALUES (1,1,'divBox.py',''),(2,1,'FDSTool.py',''),(3,3,'jacobiMain.f',''),(4,4,'summa.c','');
/*!40000 ALTER TABLE `case_code_materials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `case_versions`
--

DROP TABLE IF EXISTS `case_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `case_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `case_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `name` varchar(256) NOT NULL,
  `description` varchar(256) NOT NULL,
  `dir_path` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `case_id` (`case_id`),
  CONSTRAINT `case_versions_ibfk_1` FOREIGN KEY (`case_id`) REFERENCES `cases` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `case_versions`
--

LOCK TABLES `case_versions` WRITE;
/*!40000 ALTER TABLE `case_versions` DISABLE KEYS */;
INSERT INTO `case_versions` VALUES (1,1,1,'版本1','数据采用一个实际用户的算例，由于需要计算的建筑较大较复杂，用户划分了34个MESH ，大小差异较大，总网格量40余万：\r\n\r\n测试过程只计算10s 的模拟时间（实际计算一般需要计算30min 的模拟时间）\r\n官网下载的二进制FDS程序，采用的是预编译的OpenMPI 通信库。 最多只能使用34个进程进行计算： 测试耗时450s\r\n使用系统MPI（MPICH3）编译的FDS程序\r\n34个进程耗时182s 。因使用系统的MPI编译才能发挥HPC计算环境的高速网络的性能，通过跨节点的并行计算来提高计算能力。\r\n通','1/version_1'),(3,2,1,'版本1','','2/version_1'),(4,3,1,'版本1','没有优化','3/version_1');
/*!40000 ALTER TABLE `case_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cases`
--

DROP TABLE IF EXISTS `cases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cases` (
  `id` int(64) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `tag` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `icon` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cases`
--

LOCK TABLES `cases` WRITE;
/*!40000 ALTER TABLE `cases` DISABLE KEYS */;
INSERT INTO `cases` VALUES (1,'火灾模拟软件FDS的计算负载均衡优化','Fire dynamics simulator(FDS) 是一款用于处理火灾驱动的流体流动的开源计算流体力学CFD软件，广泛应用于建筑设计和消防安全等工程领域。FDS软件采用三维大涡模拟（Large Eddy Simulation），通过求解NS方程来分析燃烧过程中建筑内的温度场和流场的变化，但在此案例中，我们并不需要去关心具体求解过程。FDS软件支持MPI / OMP 的并行计算 , 但截止我们测试时，其公开版本（6.3.0）对MPI 并行计算有诸多限制:MPI 进程数必须少于其输入文件中的网格区域（MESH）数，并按照“前面的每个进程处理一个网格区域，最后一个进程处理剩余所有的网格区域”的方式来进行计算。这种模式使得FDS在HPC环境下直接使用难以发挥高性能计算集群的性能优势。\r\n\r\n![](/static/upload/md_images/20170108123846.png)\r\n\r\n![](/static/upload/md_images/20170108123900.png)\r\n\r\n为了能够在高性能计算环境下发挥FDS的并行计算能力，用户需要将模型切割成不同的MESH块。但一般情况下，用户建模是根据求解问题的几何特性来创建输入文件的MESH。这种建模方式导致了输入方式的各个MESH块中实际网格数量相差较大。\r\n\r\n为了能够使FDS的算例在超算上使用更大的节点规模，需要将大的MESH块拆分成小的MESH 块。通过拆分，可以提高MESH块的数量，从而提高算例的可用进程数，同时也降低了负载的不均衡性。此案例即要求用户尝试不同的切分方案来了解负载均衡对并行计算效率的影响。\r\n\r\n![](/static/upload/md_images/20170108123911.png)','','/static/upload/case/1.png'),(2,'Jacobi迭代并行优化','Jacobi迭代是一种比较常见的迭代方法，具体来说，Jacobi迭代得到的新值是原来旧值点相邻数值点的平均。Jacobi迭代的局部性很好，可以取得很高的并行性，是并行计算中常见的一个例子。将参加迭代的数据按块分割后，各块之间除了相邻的元素需要通信外，在各块的内部可以完全独立地并行计算。随着计算规模的扩大，通信的开销相对于计算来说比例会降低，这将更有利于提高并行效果。Jacobi迭代的伪代码如下所示。\r\n\r\n```\r\nREAL A(N+1,N+1), B(N+1,N+1)\r\n\r\nDO K=1,STEP\r\n	DO J=1,N\r\n		DO I=1,N\r\n			B(I,J)=0.25*(A(I-1,J)+A(I+1,J)+A(I,J+1)+A(I,J-1))\r\n		END DO\r\n	END DO\r\n\r\n	DO J=1,N\r\n		DO I=1,N\r\n			A(I,J)=B(I,J)\r\n		END DO\r\n	END DO\r\nEND DO\r\n```\r\n\r\n为了并行求解Jacobi迭代，这里将参加迭代的数据按列进行分割，并假设一共有4个进程同时并行计算。数据的分割结果如下图所示。\r\n\r\n![](/static/upload/md_images/20170108122838.png)\r\n\r\n假设需要迭代的数据是M\\*M的二维数组A(M,M)，令M=4N，按下图所示进行数据划分，则分布在四个不同进程上的数据分别是： 进程0，A(M,1:N)、 进程1， A(M,N+1:2N)、进程2，A(M,2N+1:3N)、进程3，A(M,3N+1:M)。由于在迭代过程中，边界点新值的计算需要相邻边界其它块的数据，因此在每一个数据块的两侧又各增加1列的数据空间，用于存放从相邻数据块通信得到的数据 这样原来每个数据块的大小从MN扩大到M N+2，进程0和进程1的数据块只需扩大一块即可满足通信的要求，但这里为了编程的方便和形式的一致，在两边都增加了数据块。\r\n\r\n计算和通信过程是这样的，首先对数组赋初值，边界赋为8，内部赋为0，注意对不同的进程，赋值方式是不同的（两个内部块相同 但内部块和两个外部块两两互不相同）。然后，便开始进行Jacobi迭代，在迭代之前，每个进程都需要从相邻的进程得到数据块。同时，每一个进程也都需要向相邻的进程提供数据块（如下图所示）。由于每一个新迭代点的值是由相邻点的旧值得到，所以这里引入一个中间数组用来记录临时得到的新值，一次迭代完成后，再统一进行更新操作。\r\n\r\n![](/static/upload/md_images/20170106160515.png)','','/static/upload/case/2.png'),(3,'基于MPI的矩阵相乘Summa算法实现','在科学与工程计算的许多问题中， 矩阵乘积是最基本的算法之一。经典的分布式矩阵乘积算法主要有1969年Cannon提出的二维mesh上的矩阵乘积算法和1987年Fox等提出的“广播-乘积-滚动”算法。1994年Choi等提出的PUMMA 算法将Fox 算法推广到二维块卷帘数据分布上。同年，Huss-Lederman等又将Fox算法推广到虚二维环绕数据分布。1995年van de Geijn 和Watts提出了一个简单而高效的矩阵乘积算法， 称为SUMMA 算法。\r\n\r\nSUMMA 算法首先将A, B和C划分为相同大小的矩阵，对应放在mesh_r × mesh_c的二维mesh上。但SUMMA 算法将矩阵乘法分解为一系列的秩nb 修正, 即各处理器中的A和B 分别被分解为nb 大小的列块和行块进行相乘，前面所说的分块尺寸就是指nb 的大小。算法中, 广播实现为逻辑处理器行环或列环上的流水线传送, 达到了计算与通信的重叠. 具体描述如下伪代码所示。\r\n\r\n```\r\nC= 0\r\nfor i= 0 t o k-1 step nb do\r\n　cur col = i×c/ n\r\n　cur row = i×r / m\r\n　if my col = cur rol 向本行广播A 从i mod (k/c) 列开始的nb 列, 存于A′\r\n　if my row = cur row 向本列广播B 从i mod (k/r) 行开始的nb 行, 存于B ′\r\n　C= A′×B ′\r\nend for\r\n```\r\n\r\nSUMMA算法的核心思想是：各处理器收集来自同一行处理器中A矩阵子块的所有列和同一列处理器中B矩阵子块的所有行，然后将行列相乘后累加，形成一个C矩阵的分块矩阵。最后由rank=0的处理器将其他处理器的数据收集起来，形成最终的矩阵C。SUMMA算法相较于cannon算法的优势只要体现在SUMMA算法能够计算m*l的A矩阵和l*n的B矩阵相乘（m、l、n可不相等），而cannon算法只能实现n*n的A矩阵和n*n的B矩阵相乘，具有很大的局限性。','','/static/upload/case/3.png'),(4,'图像连通区域标记并行算法','图像连通域标记算法是从一幅栅格图像（通常为二值图像）中，将互相邻接（4邻接或8邻接）的具有非背景值的像素集合提取出来，为不同的连通域填入数字标记，并且统计连通域的数目。通过对栅格图像中进行连通域标记，可用于静态地分析各连通域斑块的分布，或动态地分析这些斑块随时间的集聚或离散，是图像处理非常基础的算法。目前常用的连通域标记算法有1）扫描法（二次扫描法、单向反复扫描法等）、2）线标记法、3）区域增长法。\r\n\r\n![](/static/upload/md_images/20170108122947.png)\r\n\r\n随着所要处理的数据量越来越大，使用传统的串行计算技术的连通域标记算法运行时间过长，难以满足实际应用的效率需求。随着并行计算技术的发展，利用不同的编程模型，许多数据密集型的计算任务可以被同时分配给单机多核或多机多处理器进行并行处理，从而有可能大幅度缩减计算时间，目前在集群计算领域广泛使用MPI来进行并行化。\r\n\r\n#### 一、二次扫描串行算法思想\r\n##### 1.1 第一次扫描\r\na）标记\r\n\r\nb）等价关系建立\r\n\r\n![](/static/upload/md_images/20170108122959.png)\r\n\r\n##### 1.2 第二次扫描\r\na）利用并查集链表进行标记更新。\r\n\r\n![](/static/upload/md_images/20170108123010.png)\r\n\r\n#### 二、并行化策略\r\n##### 2.1 数据划分\r\na）二次扫描的串行算法中，非直接相邻的各像元数据之间是无关的，将图像分割为数据块后，对于各个数据块之间的主体运算也是独立无关的，可并行性较高，因此可通过对图像进行分块来加快计算时间、提高计算效率。\r\n\r\n![](/static/upload/md_images/20170108123034.png)\r\n\r\n##### 2.2 并行算法步骤\r\na）各个进程分别使用串行算法计算\r\n\r\n![](/static/upload/md_images/20170108123047.png)\r\n\r\nb）各个进程将各块的标记值唯一化\r\n\r\n![](/static/upload/md_images/20170106163224.png)\r\n\r\nc）生成等价对数组\r\n\r\n![](/static/upload/md_images/20170106163347.png)\r\n\r\nd）主进程生成全局并查集链表\r\n将1到n-1进程中比较获得的等价对数组统一发送给0号进程，0号进程生成并查集链表。\r\n\r\n![](/static/upload/md_images/20170106164811.png)\r\n\r\ne）广播全局并查集链表，各进程更改标记值\r\n主进程广播全局并查集链表，各进程接收后更新标记值。\r\n\r\n![](/static/upload/md_images/20170106165304.png)','','/static/upload/case/4.png');
/*!40000 ALTER TABLE `cases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `challenges`
--

DROP TABLE IF EXISTS `challenges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `challenges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(1024) DEFAULT NULL,
  `content` text,
  `knowledgeId` int(11) DEFAULT NULL,
  `knowledgeNum` int(11) DEFAULT NULL,
  `materialId` int(11) DEFAULT NULL,
  `source_code` text NOT NULL,
  `default_code` text,
  PRIMARY KEY (`id`),
  KEY `knowledgeId` (`knowledgeId`),
  KEY `materialId` (`materialId`),
  CONSTRAINT `challenges_ibfk_1` FOREIGN KEY (`knowledgeId`) REFERENCES `knowledges` (`id`),
  CONSTRAINT `challenges_ibfk_2` FOREIGN KEY (`materialId`) REFERENCES `materials` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `challenges`
--

LOCK TABLES `challenges` WRITE;
/*!40000 ALTER TABLE `challenges` DISABLE KEYS */;
INSERT INTO `challenges` VALUES (63,'并行计算的定义','考虑下述问题：图书馆将一些书上架，可以有多种方式。假定将书按类上架，而将书架依据在书库中的位置分成一些组。若由一工人单独完成，不能按某一要求的速度完成任务。若由多个工人完成， 假定每次一人仅往书架上放一本书。\n\n1. 将所有的书籍平均分配给每个人去完成。这种划分方法不是太有效，原因是每个工人为了将书上架必须走遍所有的书架。\n2. 将所有书架分成一些组，且平均分配给各个工人负责，同时将所有图书平均分配给每个工人去上架。如果工人发现一本书属于自己所负责的书架上，则将其放入书架。否则，将这本书传给所在书架对应的工人。这种分法对应的效率比较高。 \n\n上述例子说明：将一个任务划分成一些子任务，并分配给多个工人去完成，工人们相互合作、并在需要时相互传递图书，这种和谐协调的工作方式可较快地完成任务。\n\n并行计算就是严格地按照上述原理来完成的。上述例子涉及到了与并行计算相关的两个概念：\n\n1.  任务划分(task partitioning): 将图书平均分配给所有工人为任务划分的一个例子。\n2.  通信(communication): 工人之间传递图书为子任务通信的例子。 \n\n并行计算的定义：并行计算是指同时对多个任务或多条指令、或对多个数据项进行处理。完成此项处理的计算机系统称为并行计算机系统，它是将多个处理器（可以几个、几十个、几千个、几万个等）通过网络连接以一定的方式有序地组织起来（一定的连接方式涉及网络的互联拓扑、通信协议等，而有序的组织则涉及操作系统、中间件软件等）。\n\n并行计算的主要目的：\n\n* 一是为了提供比传统计算机快的计算速度；\n* 二是解决传统计算机无法解决的问题。\n',4,1,NULL,'#include<iostream>\r\nusing namespace std;','#include<iostream>\n'),(64,'并行计算的研究内容','并行计算的研究内容广泛，包括并行计算机系统结构、并行算法设计、并行编程环境等，具体表现在下面几个方面：\n\n* 并行计算机的设计：包括本并行计算机的结构设计、互联拓扑、网络通信等。设计并行计算机重要的一点要考虑处理机数目的按比例增长（即可扩展性）及支持快速通信及处理机间的数据共享等。\n* 有效算法的设计：如果没有有效的并行算法，并行计算机无法使用，而并行算法的设计完全不同于串行算法的设计，不同的并行计算机的算法设计不同，只有将不同的并行计算机与不同的实际问题相结合，才能设计出有效的并行算法。主要研究内容包括并行计算模型、并行算法的一般设计方法、基本设计技术和一般设计过程，并讨论一些数值并行算法与非数值并行算法的设计。\n* 评价并行算法的方法：对于给定的并行计算机及运行在上面的并行算法，需要评价运行性能。性能分析需解决的问题：如何利用基于并行计算机及其相适应的并行算法去快速地解决问题，及如何有效地利用各个处理器。研究内容包括结合机器与算法，提出相应的性能评测指标，为设计高效的并行算法提供依据。\n* 并行计算机语言：与传统的机器语言不同，并行计算机语言依赖于并行计算机，并行计算机语言必须简洁，编程容易，可以有效地实现，目前的语言有：PVM、MPI、HPF等，而且新的编程语言于编程模式正在不断地出现。\n* 并行编程环境与工具：为了使编程容易，必须开发综合的编程环境与工具，且能达到两个目的：并行计算机的底层机构对用户透明；为用户提供设计与开发程序所需要的调试器与模拟器等工具，\n* 并行程序的可移植性：可移植性为并行程序设计的主要问题，要求在一台并行机上开发的程序不加修改或进行少量修改即可在另一台计算机上运行。这一点为目前受到了广泛关注的重要课题。\n* 并行计算机的自动编程：可否设计一个并行化编译器，使用户的串行程序通过并行化编译器编译，直接可在并行机上运行。到目前为此，这种编译器还不存在，而仅有一些半自动并行化编译器。\n\n### 并行计算的应用范围\n\n并行计算在许多计算机应用领域都产生了巨大的影响，使原来无法解决的应用问题成为可能。\n\n例如：天气预报。考虑3000\\*3000平方公里的范围，垂直方向的考虑高度为11公里。将3000*3000*11立方公里的区域分成0.1\\*0.1\\*0.1立方公里的小区域，则将近有1011个不同的小区域。另外还需考虑时间因素，将时间参数量化。假定考虑48小时天气预报。\n\n每一小区域的计算包括参数的初始化及与其它区域的数据交换。若每一小区域计算的操作指令为100条，则整个范围一次计算的指令为1011\\*100=1013，两天的计算次数将近100次，因此，指令总数为1015条。用一台10亿次/秒(PIII500)计算，将大约需要280小时。若我们用100个10亿次/秒的处理器构成一台并行处理机，每个处理器计算的区域为108个，不同的处理器通过通信来传输参数，若个处理器的计算能力得到充分利用，则整个问题的计算时间不超过3小时。说明两点:\n\n1. 并行计算机可以解决原先不能解决的问题；\n2. 可进行更准确的天气预报。	\n\n其它应用包括：卫星数据处理、石油数据处理（连续优化问题），调度问题、平面性问题及VLSI设计（离散优化问题）\n美国HPCC计划（High Performance Computing and Communication）提出了重大挑战性问题，对科学与工程具有重大的经济与科学意义的一些基础课题，它们的解可通过高性能并行计算技术得到。\n\n美国HPCC计划公布的重大挑战性应用 \n\n1. 磁记录技术：研究静磁和交互感应以降低高密度磁盘的噪音\n2. 新药设计：通过抑制人的免疫故障病毒蛋白酶的作用来研制治疗癌症与艾滋病的药物\n3. 高速民航：用计算流体动力学来研制超音速喷气发动机\n4. 催化作用：仿生催化剂计算机建模，分析合成过成中的酶作用\n5. 燃料燃烧：通过化学动力学计算，揭示流体力学的作用，设计新型发动机\n6. 海洋建模：对海洋活动与大气流的热交换进行整体海洋模拟\n7. 臭氧耗损：研究控制臭氧损耗过程中的化学与动力学机制\n8. 数字解析：用计算机研究适时临床成像、计算层析术、磁共振成像 \n9. 大气污染：对大气质量模型进行模拟研究，控制污染的传播，揭示其物理与化学机理\n10. 蛋白质结构设计：对蛋白质组成的三维结构进行计算机模拟研究\n11. 图像理解：实时绘制图像或动态\n12. 密码破译：破译由长位数组成的密码，寻找该数的两个乘积因子',4,2,NULL,'#include<iostream>\r\nusing namespace std;','#include<iostream>'),(65,'并行计算的应用分类','科学与工程计算对并行计算的需求是十分广泛的，但所有的应用可概括为三个方面：\n\n* 计算密集型（Compute-Intensive）：这一类型的应用问题主要集中在大型科学工程计算与数值模拟（气象预报、地球物理勘探等）\n* 数据密集型 (Data-Intensive)：Internet的发展，为我们提供了大量的数据资源，但有效地利用这些资源，需要进行大量地处理，且对计算机的要求也相当高，这些应用包括数字图书馆、数据仓库、数据挖掘、计算可视化。\n* 网络密集型 (Network-Intensive)：通过网络进行远距离信息交互，来完成用传统方法不同的一些应用问题。如协同工作、遥控与远程医疗诊断等',4,3,NULL,'#include<iostream>\r\nusing namespace std;','#include<iostream>'),(66,'并行计算机的控制结构','对并行计算机的分类有多种方法，其中最著名的是1966年由M.J.Flynn提出的分类法，称为Flynn分类法。Flynn分类法是从计算机的运行机制进行分类的。首先作如下定义：\n\n* 指令流（instruction stream）：机器执行的指令序列；\n* 数据流（data stream）：由指令流调用的数据序列，包括输入数据和中间结果。\n\nFlynn根据指令流和数据流的不同组织方式，把计算机系统的结构分为以下四类：\n\n* 单指令流单数据流（Single Instruction stream Single Data stream, SISD）；\n* 单指令流多数据流（Single Instruction stream Multiple Data stream, SIMD）；\n* 多指令流单数据流（Multiple Instruction stream Single Data stream, MISD）；\n* 多指令流多数据流（Multiple Instruction stream Multiple Data stream, MISD）。\n\nSISD就是普通的顺序处理的串行机。SIMD和MIMD是典型的并行计算机。MISD在实际中代表何种计算机，也存在不同的看法，甚至有学者认为根本不存在MISD。有的文献把流水线结构的计算机看成MISD结构。\n\n在一台SIMD计算机中，有一个控制部件（又称为控制单元，control unit）和许多处理单元（processing unit）。大量的处理单元通常构成阵列，因此SIMD计算机有时也称为阵列处理机。所有的处理单元在控制部件的统一控制下工作。控制部件向所有的处理单元广播同一条指令，所有的处理单元同时执行这条指令，但是每个处理单元操作的数据不同。控制部件可以有选择地屏蔽掉一些处理单元，被屏蔽掉的处理单元不执行控制部件广播的指令。典型的SIMD计算机有Illiac IV, Goodyear MPP, DAP, CM-2, MasPar MP-1和MasPar MP-2等。\n\n在MIMD计算机中没有统一的控制部件。在MIMD中，各处理器可以独立地执行不同的指令。实际上，在SIMD机中，各处理单元执行的是同一个程序，而在MIMD机上，各处理器可以独立执行不同的程序。在MIMD中，每个处理器都有控制部件，各处理器通过互连网络进行通信。MIMD结构比SIMD结构更加灵活。SIMD计算机通常要求实际问题包含大量的对不同数据的相同运算（例如向量运算和矩阵运算）才能发挥其优势。而MIMD计算机则无此要求，它可以适应更多的并行算法，因此可以更加充分地开掘实际问题的并行性。SIMD所使用的CPU通常是专门设计的，而MIMD可以使用通用CPU。后面将会介绍各种MIMD计算机。\n\n随着并行计算技术的不断发展，近来又出现了SPMD，MPMD等概念。SPMD是指单程序多数据（Single Program Multiple Data），MPMD是指多程序多数据（Single Program Multiple）。在SPMD机制中，各处理器有自己的控制部件。各处理器并行地执行同一个程序，但所操作的数据不一定相同。与相比SIMD，在SPMD模式下，各处理器只在需要时进行同步，而不是同步地执行每一条指令。在某一时刻，不同的处理器执行的指令可能不相同。SPMD易于在机群系统和MPI（一种并行编程环境）的支持下得以实现，因此被广泛使用。',4,4,NULL,'#include<iostream>\r\nusing namespace std;','#include<iostream>'),(67,'SIMD计算机','SIMD计算机结构如下图所示，其中PE表示处理单元，P表示处理器，M表示存储器。\n\n![](/static/upload/md_images/20161219110021.png)\n\nSIMD中通常包含大量处理单元PE，而控制部件只有一个。控制部件广播一条指令，所有的处理单元同时执行这条指令，但不同的处理单元操作的数据可能不同。\n\n典型的SIMD计算机有MasPar公司的MP-1系列，Thinking Machines公司的CM-2，Illiac IV，BSP等。MasPar MP-1最多可容纳16384个处理器。当配置16384个处理器时，32位的整数操作的峰值性能可达26000MIPS，单精度浮点运算性能达1.5GFlops，双精度浮点运算性能达650MFlops。CM-2有65536个处理单元，峰值速度达到28GFlops，持续速度达到5.6GFlops。',4,5,NULL,'#include<iostream>\r\nusing namespace std;','#include<iostream>'),(68,'并行向量处理机','在并行向量处理机中有少量专门定制的向量处理器。每个向量处理器有很高的处理能力。并行向量处理机通过向量处理和多个向量处理器并行处理两条途径来提高处理能力。Cray C-90、Cray T-90、NEC SX-4和我国的银河1号都是PVP。PVP通常使用定制的高带宽网络将向量处理器连向共享存储器模块。存储器可以以很高的速度向处理器提供数据。例如，在Cray T-90中，共享存储器能以14GB/s的速率将数据提供给一个处理器。这种机器通常不使用高速缓存，而是使用大量的向量寄存器和指令缓冲器。其系统结构如下图所示。图中VP表示向量处理器，SM表示共享存储器。\n\n![](/static/upload/md_images/20161219111123.png)\n\n**对称多处理机 **\n\n对称多处理机的最大特点是其中的各处理器完全平等，无主从之分。所有的处理器都可以访问任何存储单元和I/O设备。存储器一般使用共享存储器，只有一个地址空间。因为使用共享存储器，通信可用共享变量（读写同一内存单元）来实现。这使得编程很容易。典型的对称多处理机有Sun SPARC server 10000，Sun SPARC center 2000，SGI Power Challenge以及我国的曙光1号。SMP广泛地用于服务器领域。SMP的结构如下图所示。P/C表示处理器和高速缓存，SM表示共享存储器。\n\n![](/static/upload/md_images/20161219111242.png)\n\n',4,6,NULL,'#include<iostream>\r\nusing namespace std;','#include<iostream>');
/*!40000 ALTER TABLE `challenges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classifies`
--

DROP TABLE IF EXISTS `classifies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classifies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classifies`
--

LOCK TABLES `classifies` WRITE;
/*!40000 ALTER TABLE `classifies` DISABLE KEYS */;
INSERT INTO `classifies` VALUES (4,'并行编程入门'),(5,'并行默认题库'),(7,'余华山老师题目');
/*!40000 ALTER TABLE `classifies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rank` int(11) DEFAULT NULL,
  `content` varchar(2048) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `courseId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `courseId` (`courseId`),
  KEY `userId` (`userId`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`courseId`) REFERENCES `courses` (`id`),
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,4,'1212','2016-11-21 14:02:21',1,1),(2,4,'评价2','2016-11-18 00:00:00',1,2),(3,3,'评价3','2016-11-18 00:00:00',1,3),(4,2,'评价4','2016-11-18 00:00:00',1,4),(5,1,'评价5','2016-11-18 00:00:00',1,5),(6,4,'12123','2016-11-21 13:58:47',2,1),(7,3,'好好好','2016-11-21 13:59:18',3,1),(8,1,'12345','2016-11-22 16:19:11',5,1),(9,1,'122444','2016-11-21 23:12:57',5,2);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_users`
--

DROP TABLE IF EXISTS `course_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_users` (
  `course_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  KEY `user_id` (`user_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `course_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `course_users_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_users`
--

LOCK TABLES `course_users` WRITE;
/*!40000 ALTER TABLE `course_users` DISABLE KEYS */;
INSERT INTO `course_users` VALUES (3,1),(4,1),(5,4),(1,7),(5,1),(1,9),(1,3);
/*!40000 ALTER TABLE `course_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) DEFAULT NULL,
  `subtitle` varchar(128) DEFAULT NULL,
  `about` text,
  `createdTime` datetime DEFAULT NULL,
  `lessonNum` int(11) NOT NULL,
  `studentNum` int(11) DEFAULT NULL,
  `smallPicture` varchar(128) DEFAULT NULL,
  `middlePicture` varchar(128) DEFAULT NULL,
  `largePicture` varchar(128) DEFAULT NULL,
  `rank` float(3,2) DEFAULT NULL,
  `public` tinyint(1) DEFAULT '1',
  `beginTime` datetime DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_courses_title` (`title`),
  KEY `courses_ibfk_1` (`user_id`),
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'并行计算课','并行计算课学习并行运算的相关知识','# 1. 课程内容体系结构\n\n“并行计算”是“并行算法类教学体系”中的核心内容之一，它是处于并行算法类教学体系中的算法应用基础层次，是面向计算机专业本科高年级学生或从事计算科学的研究生的，是为了适应高性能计算机迅速发展的形势，满足国家培养面向21世纪高科技人才之需求。为此本课程在内容体系上力求有所创新，而在遵循课程自身学科性、系统性和完整性的同时，应充分考虑不同应用领域在并行计算机上求解大型科学工程问题的需求，将并行机体系结构、并行数值计算、并行算法和并行编程等课程的内容有机的整合在一起，在国内形成一门新型的“并行计算”课程。\n \n# 2. 教学内容组织方式与目的\n\n* 教学内容组织方式: 全课程的教学内容组织成为四篇：第一篇为并行计算的硬件基础，包括并行计算机的系统结构模型、当代并行计算机系统介绍和并行计算性能评测；第二篇为并行算法的设计，包括并行算法通用设计策略、基本设计技术和一般设计过程；第三篇为并行数值算法，包括矩阵运算、线性方程组求解和快速傅氏变换；第四篇为并行程序设计，包括并行程序设计基础、共享存储系统并行编程、分布式存储系统并行编程和并行程序设计环境与工具。\n* 教学目的: 本课程以并行计算为主题、要求讲授并行计算的硬件平台（当代并行计算机系统及其结构模型）、软件支撑（并行程序设计）和理论基础（并行算法的设计和并行数值算法）。在内容组织上，强调融并行机结构、并行算法和并行编程为一体，着重讨论并行算法的设计及其实现，并力图反映本学科的最新成就和发展趋势，体现出并行机硬件和软件相结合以及并行算法和并行编程相结合。\n\n# 3.实践性教学的设计与效果\n\n“并行计算”是一门实践性很强的课程，除了系统的课堂理论学习外，还配有足够数量的实践内容，以巩固和加深学生对并行算法理论、设计技术、分析方法和具体实现等各个环节的整体理解。通过课程实践，强化学生“结构—算法—编程”一体化学习方法的意识，充分理解对于求解一个给定问题的任何并行算法，都必须采用某种并行编程语言，最终运行在一台具体的并行计算\n\n根据并行计算课程的要求，其实验教学的要求如下：\n\n- 熟悉三种以上的主流并行计算平台，包括共享存储的多处理机、分布存储的多计算机和目前流行的PC机群，要求学生能够使用上述几种并行计算平台所提供的硬／软件环境及工具来开展自己的实验工作。\n- 掌握至少两种并行程序设计语言标准：即分布存储的MPI和共享存储的OpenMP。对面向大型科学和工程计算的HPF（高性能Fortran）也应尽量了解和熟悉。\n- 选择某些典型的非数值并行算法和数值并行算法，使用上述的并行编程语言标准，至少在PC机群上编程调试、分析和运行它们。\n- 为了入门，选用课程中简单的计算π的样本程序为出发点，通过使用不同的并行程序设计模型和不同的并行编程语言，在不同的硬件编程环境上改造和重现，以便为进一步的实践打下基础。','2016-10-20 00:00:00',29,3,'upload/course/8.jpg',NULL,NULL,2.80,0,'2017-01-03 13:01:11','2017-02-03 23:35:04',3),(2,'并行计算介绍','以下内容仅用于系统测试，知识产权归课件开发者所有','# 1. Overview\nParallel computing has become the dominant technique for achieving high performance in computational science and engineering research. Parallel computing systems are now becoming mainstream in commercial sectors as well, due to the performance demands and requirements of today\'s engineering, database, and financial applications. Multiprocessor systems based on commodity processors (IA32, IA64, G4, Alpha, UltraSparc, Power3, Power4) are now common and offer excellent performance for the price. However, parallel computing is relatively new to college curricula; until recently, parallel computing was largely learned on the side (for research scientists) or on the job (in industry).\nThis class will discuss architectures of modern parallel computers (briefly) and will teach students how to write parallel programs for these parallel computers. This class will be very \'applied\' in nature: there will be more emphasis on parallel programming libraries than on abstract theoretical parallel programming concepts or computer engineering details.\n# 2.  Prerequisites\nStudents must have prior programming experience using either C or Fortran. Experience using Unix workstations and developing scientific codes is helpful but not required.\n# 3.  Topics\n* Overview of Parallel Computing(Majumdar): parallel computing concepts, parallel computer architectures, and standard programming models for parallel computers.\n* Shared Memory Parallel Programming with OpenMP (Majumdar): OpenMP features and syntax, examples of parallelizing serial codes with OpenMP, discussion of performance issues.\n* Distributed Memory Programming with Message Passing Interface (MPI) (Majumdar): MPI features and syntax, examples of parallelizing serial codes with MPI, discussion of performance issues.\n* Single Processor Optimization (Valafar): overview of microprocessor architectures, utilizing microprocessor features (registers, cashes, etc.) effectively, characteristics and potential bottlenecks that determine maximum deliverable performance for code segments, and measuring and improving code performance.','2016-09-20 08:00:00',3,0,'upload/course/cover_2.png',NULL,NULL,4.00,1,NULL,NULL,3),(3,'并行计算原理与实践','以下内容仅用于系统测试，知识产权归课件开发者所有','# 1. Course Description\nThe students will get the skills to use some of the best existing parallel programming tools, and be exposed to a number of open research questions. This course will:\n\n* provide an introduction to parallel computing including parallel computer architectures, analytical modeling of parallel programs, the principles of parallel algorithm design.\n* include material on TBB, OpenMP, CUDA, OpenCL, MPI, MapReduce.\n\n# 2. Prerequisite\nC language, discrete mathematics, data structure, principles of computer composition, operating system, C++, algorithms\n\n# 3. Syllabus\n* **Part 1: Principle (Lecture 1-5)**\n	\n	This section covers the very basics of parallel computing, and is intended for someone who is just becoming acquainted with the subject. It begins with a brief overview, including concepts and terminology associated with parallel computing. The topics of parallel memory architectures and programming models are then explored. These topics are followed by a discussion on a number of issues related to designing parallel programs.\n\n* **Part 2: Typical Issues Solved by Parallel Programming (Lecture 6-10)**\n	\n	This section concludes with several examples of how to parallelize simple serial programs. Including: threads and shared memory programming with TBB and OpenMP, SIMD programming model and Cuda & OpenCL, programming using the Message Passing Paradigm, parallel computing with MapReduce.\n\n* **Part 3: Parallel Programming Case Study and Assignment (Lecture 11 and Assignment)**\n	\n	Students in this course are required to complete several assignments, which accounts for 30% of their grade.','2016-09-21 00:00:00',12,1,'upload/course/cover_3.png',NULL,NULL,3.00,1,NULL,NULL,3),(4,'并行编程','以下内容仅用于系统测试，知识产权归课件开发者所有','# 1. Background and Description\nThis course is a comprehensive exploration of parallel programming paradigms, examining core concepts, focusing on a subset of widely used contemporary parallel programmingmodels, and providing context with a small set of parallel algorithms. In the last few years, this area has been the subject of significant interest due to a number of factors. Most significantly, the advent of multi-core microprocessors has made parallel computing available to the masses. At the high end, major vendors of large-scale parallel systems, including IBM, and Cray, have recently introduced new parallel programming languages designed for applications that exploit tens of thousands of processors. Embedded devices can also be thought of as small multiprocessors. The convergence of these distinct markets offers an opportunity to finally provide application programmers with a productive way to express parallel computation.\n\nThe course will be structured as lectures, homeworks, programming assignments and a final project. Students will perform four programming projects to express algorithms using selected parallel programming models and measure their performance. The final project will consist of teams of 2-3 students who will implement codes by combining multiple programming models.\n\n# 2. Prerequisites\nCS 4400, or concurrent\n','2016-09-22 00:00:00',24,1,'upload/course/cover_4.png',NULL,NULL,0.00,0,'2017-01-03 13:03:37','2017-02-23 14:50:34',3),(5,'并行方法在数值分析中的应用','以下内容仅用于系统测试，知识产权归课件开发者所有','# 1. Course Description\nEmphasis is on techniques for obtaining maximum parallelism in numerical algorithms, especially those occurring when solving matrix problems, partial differential equations, and the subsequent mapping onto the computer. Implementation issues on parallel computers. Topics: parallel architecture, programming models (MPI, GPU Computing with CUDA ¿ quick review), matrix computations, FFT, fast multiple methods, domain decomposition, graph partitioning, discrete algorithms.\n\n# 2. Prerequisites\n302 or 200 ( ME 300A), 213 or equivalent, or consent of instructor. Recommended: differential equations and knowledge of a high-level programming language such as C or C++ (F90/95 also allowable).','2016-09-23 01:00:00',13,2,'upload/course/cover_5.png',NULL,NULL,1.00,1,NULL,NULL,3),(6,' CUDA Programming on NVIDIA GPUs','以下内容仅用于系统测试，知识产权归课件开发者所有','# 1. Course Description\nThe course consists of approximately 3 hours of lectures and 4 hours of practicals each day. The aim is that by the end of the course you will be able to write relatively simple programs and will be confident and able to continue learning through studying the examples provided by NVIDIA as part of their SDK (software development kit). \n\n# 2. Preliminary Reading\n* Please read chapters 1 and 2 of the NVIDIA CUDA C Programming Guide. \n\n* CUDA is an extension of C/C++, so if you are a little rusty with C/C++ you should refresh your memory of it. ','2016-09-29 01:00:00',11,0,'upload/course/cover_6.png',NULL,NULL,0.00,0,'2017-01-03 13:04:21','2017-01-28 15:35:17',3),(9,'MPI Programing','以下内容仅用于系统测试，知识产权归课件开发者所有','# Abstract\nThe Message Passing Interface Standard (MPI) is a message passing library standard based on the consensus of the MPI Forum, which has over 40 participating organizations, including vendors, researchers, software library developers, and users. The goal of the Message Passing Interface is to establish a portable, efficient, and flexible standard for message passing that will be widely used for writing message passing programs. As such, MPI is the first standardized, vendor independent, message passing library. The advantages of developing message passing software using MPI closely match the design goals of portability, efficiency, and flexibility. MPI is not an IEEE or ISO standard, but has in fact, become the \"industry standard\" for writing message passing programs on HPC platforms.\n\nThe goal of this tutorial is to teach those unfamiliar with MPI how to develop and run parallel programs according to the MPI standard. The primary topics that are presented focus on those which are the most useful for new MPI programmers. The tutorial begins with an introduction, background, and basic information for getting started with MPI. This is followed by a detailed look at the MPI routines that are most useful for new MPI programmers, including MPI Environment Management, Point-to-Point Communications, and Collective Communications routines. Numerous examples in both C and Fortran are provided, as well as a lab exercise.\n\nThe tutorial materials also include more advanced topics such as Derived Data Types, Group and Communicator Management Routines, and Virtual Topologies. However, these are not actually presented during the lecture, but are meant to serve as \"further reading\" for those who are interested.\n\n# Level/Prerequisites\nThis tutorial is ideal for those who are new to parallel programming with MPI. A basic understanding of parallel programming in C or Fortran is required. For those who are unfamiliar with Parallel Programming in general, the material covered in EC3500: Introduction To Parallel Computing would be helpful. ','2016-10-23 08:58:17',2,0,'upload/course/cover_9.png',NULL,NULL,0.00,1,NULL,NULL,3),(10,'并行计算机体系结构','以下内容仅用于系统测试，知识产权归课件开发者所有','# 并行计算机\n并行计算机就是由多个处理单元组成的计算机系统，这些处理单元相互通信和协作，能快速，高效地求解大型复杂问题。\n# 涉及问题\n* **资源分配**\n	1. 并行计算机系统有多大? \n    2. 处理单元的性能如何?\n	3. 购买价格如何?\n\n* **数据存取, 通信 以及 同步** \n	1. 各处理单元如何协作及通信?\n	2. 数据如何在各处理机间传送?\n	3. 什么是协作的概念?\n\n* **性能与规模**\n	1. 如何将之全部转化为高性能?\n	2. 如何对其进行评测?\n','2016-12-12 12:48:28',8,0,'upload/course/cover_10.png',NULL,NULL,0.00,1,NULL,NULL,3),(11,'并行算法的设计与分析','以下内容仅用于系统测试，知识产权归课件开发者所有','# 课程目标\n* 通过课程讲授、课程论文和课堂讨论的方式使同学们掌握各种并行计算模型上常用的、基本的、典型的并行算法设计和分析，以及在各自研究领域中的应用\n\n# 课程内容\n* 并行机结构模型、并行计算模型、并行算法基本知识\n* 非数值并行算法：排序、选择、组合搜索、串匹配、图论算法等\n* 数值并行算法：矩阵运算、线性方程组求解、FFT算法等\n* 并行计算理论初步和并行算法的应用举例\n','2016-12-12 13:12:49',13,0,'upload/course/cover_11.png',NULL,NULL,0.00,1,NULL,NULL,3),(12,'并行计算基础','以下内容仅用于系统测试，知识产权归课件开发者所有','# 1. 集群计算\n集群计算主要研究方向是并行计算所需的各种工具，如并行调试器、容错工具、性能调试、 并行化编译等等，另外还包括集群计算的实际应用程序的开发，如生物信息学、电力系统模 拟与仿真等。\n\n随着计算机体系结构的发展，并行处理重新成为了研究热点。原因是单内核处理器的发展已 经遇到了瓶颈，进一步提高 CPU 的性能必须从多内核入手， Intel 公司目前大部分的研究 工作都开始以多内核为基础。8 － 16 内核的处理器现在已经是桌面和服务器的主流， 如何有效地利用多内核处理器系统对于研究者来说仍然是一个新 的挑战。需要在并行处理的体系结构、并行算法、并行编程工具以及运行时系统等多个方面 进行更加深入的研究。可以预计，此方向的研究在今后 10 年之内仍然会持续成为研究的热 点。\n\n# 2. 开设本课程的动机\n* 并行系统已经逐渐成为主流\n\n	(1) 多核已经成为趋势\n\n	(2) 桌面系统已经成为并行系统，而且核数增加，软件需要从串行变为并行\n\n	(3) 集群已经大量普及，但当前的并行编程方法、工具还是专家们所掌握\n\n* 并行不再是少数人的专利，并行计算有可能成为通用计算技术\n* 并行计算的使用者来自各个领域，但对并行编程的熟悉程度还不高\n\n# 3. 课程目标\n* 不是单纯理论学习课，偏重实践的课程 \n* 实实在在体验并行软件开发过程\n\n# 4. 得到的收获\n* 在今后采用并行计算方法提升程序性能\n* 能编写一定规模的并行程序\n* 知道使用并行工具提高并行程序实现效率\n* 初步了解并行计算程序设计的过程\n* 了解最新的众核/异构并行技术','2016-12-16 15:22:12',12,0,'upload/course/cover_12.png',NULL,NULL,0.00,1,NULL,NULL,3),(14,'并行程序设计','北京大学信息科学技术学院 余华山老师','[课程网页](http://course.pku.edu.cn)','2016-12-31 20:45:39',14,0,'upload/course/cover_14.png',NULL,NULL,0.00,1,NULL,NULL,3);
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_members`
--

DROP TABLE IF EXISTS `group_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_members` (
  `group_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  KEY `user_id` (`user_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `group_members_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `group_members_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_members`
--

LOCK TABLES `group_members` WRITE;
/*!40000 ALTER TABLE `group_members` DISABLE KEYS */;
INSERT INTO `group_members` VALUES (2,2),(3,1),(4,1),(1,1),(1,4),(2,1),(2,3),(2,7),(15,7),(15,1);
/*!40000 ALTER TABLE `group_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `about` text NOT NULL,
  `logo` varchar(128) DEFAULT NULL,
  `memberNum` int(11) DEFAULT NULL,
  `topicNum` int(11) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (1,'C++讨论','这里讨论 C++ 的基础知识，欢迎一起来讨论C++编程啊！','/static/upload/group_logo/1.png?t=1481772698.14',2,4,'2016-09-20 00:00:00'),(2,'意见反馈','反馈给站点的意见','/static/upload/group_logo/2.jpg',4,2,'2016-08-20 00:00:00'),(3,'学习交流','在这里交流学习的心得体会','/static/upload/group_logo/3.jpg',0,1,'2016-10-20 00:00:00'),(4,'使用指南','网站使用指南','/static/upload/group_logo/4.jpg',1,2,'2016-09-20 00:00:00'),(6,'并行运算','并行运算课程群','/static/upload/group_logo/6.jpg',0,1,'2016-09-20 00:00:00'),(15,'测试群组','这是一个测试群组','/static/upload/group_logo/15.png?t=1477277568.0',2,2,'2016-10-24 10:52:49');
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `homework`
--

DROP TABLE IF EXISTS `homework`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `homework` (
  `id` int(64) NOT NULL AUTO_INCREMENT,
  `title` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `publish_time` datetime NOT NULL,
  `deadline` datetime NOT NULL,
  `course_id` int(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `homework_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `homework`
--

LOCK TABLES `homework` WRITE;
/*!40000 ALTER TABLE `homework` DISABLE KEYS */;
INSERT INTO `homework` VALUES (3,'作业1','# Cost Function\r\n\r\nLet\'s first define a few variables that we will need to use:\r\n\r\n* L = total number of layers in the network\r\n* \\(s_l\\) = number of units (not counting bias unit) in layer l\r\n* K = number of output units/classes\r\n\r\nRecall that in neural networks, we may have many output nodes. We denote \\(h_{\\Theta}(x)_k\\) as being a hypothesis that results in the \\(k^{th}\\) output. Our cost function for neural networks is going to be a generalization of the one we used for logistic regression. Recall that the cost function for regularized logistic regression was:\r\n\r\n\\[J(\\theta) = - \\frac{1}{m} \\sum_{i=1}^m [ y^{(i)}\\ \\log (h_\\theta (x^{(i)})) + (1 - y^{(i)})\\ \\log (1 - h_\\theta(x^{(i)}))] + \\frac{\\lambda}{2m}\\sum_{j=1}^n \\theta_j^2\\]\r\n\r\nFor neural networks, it is going to be slightly more complicated:\r\n\r\n\\[\\begin{gather*} J(\\Theta) = - \\frac{1}{m} \\sum_{i=1}^m \\sum_{k=1}^K \\left[y^{(i)}_k \\log ((h_\\Theta (x^{(i)}))_k) + (1 - y^{(i)}_k)\\log (1 - (h_\\Theta(x^{(i)}))_k)\\right] + \\frac{\\lambda}{2m}\\sum_{l=1}^{L-1} \\sum_{i=1}^{s_l} \\sum_{j=1}^{s_{l+1}} ( \\Theta_{j,i}^{(l)})^2\\end{gather*}\\]\r\n\r\nWe have added a few nested summations to account for our multiple output nodes. In the first part of the equation, before the square brackets, we have an additional nested summation that loops through the number of output nodes.\r\n\r\nIn the regularization part, after the square brackets, we must account for multiple theta matrices. The number of columns in our current theta matrix is equal to the number of nodes in our current layer (including the bias unit). The number of rows in our current theta matrix is equal to the number of nodes in the next layer (excluding the bias unit). As before with logistic regression, we square every term.\r\n\r\nNote:\r\n\r\n* the double sum simply adds up the logistic regression costs calculated for each cell in the output layer\r\n* the triple sum simply adds up the squares of all the individual Θs in the entire network.\r\n* the i in the triple sum does **not** refer to training example i.\r\n\r\n','2016-12-25 15:45:01','2017-02-05 23:55:42',1),(4,'作业2','查阅资料，找出一个并行计算的典型应用，详细描述该应用在并行化方面成功和失败之处以及遇到的困难：（从下列方面考虑：该应用是针对什么科学或者工程上的具体问题设计的；对于要解决的问题，该应用实际效果怎样，模拟结果和物理结果进行比较的结果如何；该应用的运行在什么并行计算平台上；（比如分布式或共享内存，向量机）这个应用使用那种开发工具开发的；该应用的实际工作性能怎样，和运行平台最佳性能相比较；该应用的可扩展性如何？如果不好，你认为它的扩展性的瓶颈在何处？）','2016-12-25 15:45:29','2016-12-28 15:45:32',1),(5,'作业3','作业3','2017-01-08 11:49:21','2017-02-03 11:50:21',1);
/*!40000 ALTER TABLE `homework` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `homework_upload`
--

DROP TABLE IF EXISTS `homework_upload`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `homework_upload` (
  `id` int(64) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `homework_id` int(64) NOT NULL,
  `user_id` int(64) NOT NULL,
  `uri` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `submit_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `homework_id` (`homework_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `homework_upload_ibfk_1` FOREIGN KEY (`homework_id`) REFERENCES `homework` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `homework_upload_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `homework_upload`
--

LOCK TABLES `homework_upload` WRITE;
/*!40000 ALTER TABLE `homework_upload` DISABLE KEYS */;
INSERT INTO `homework_upload` VALUES (1,'ch1.pdf',3,3,'course_1/homework_3/ch1.pdf','2016-12-27 10:48:52'),(2,'ch2.pdf',3,3,'course_1/homework_3/ch2.pdf','2016-12-27 10:49:02');
/*!40000 ALTER TABLE `homework_upload` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knowledges`
--

DROP TABLE IF EXISTS `knowledges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knowledges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(1024) NOT NULL,
  `content` text,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `knowledges_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledges`
--

LOCK TABLES `knowledges` WRITE;
/*!40000 ALTER TABLE `knowledges` DISABLE KEYS */;
INSERT INTO `knowledges` VALUES (4,'并行编程入门','本内容以并行计算为主题，由并行结构、并行算法、并行编程及并行算法实例四部分内容构成，强调并行结构、并行算法、并行程序设计的有机联系，从基础、算法实例、算法分析、算法实现以及应用各个角度介绍了并行计算的基本技术。',3);
/*!40000 ALTER TABLE `knowledges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lab_programs`
--

DROP TABLE IF EXISTS `lab_programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lab_programs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_code` text NOT NULL,
  `default_code` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lab_programs`
--

LOCK TABLES `lab_programs` WRITE;
/*!40000 ALTER TABLE `lab_programs` DISABLE KEYS */;
INSERT INTO `lab_programs` VALUES (1,'#include<iostream>\r\nusing namespace std;\r\nint main()\r\n{\r\n  cout<<\"hello world\"<<endl;\r\n}','#include<iostream>\r\nusing namespace std;\r\nint main()\r\n{\r\n  \r\n}');
/*!40000 ALTER TABLE `lab_programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lessons`
--

DROP TABLE IF EXISTS `lessons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lessons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` int(11) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `content` text,
  `courseId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `courseId` (`courseId`),
  CONSTRAINT `lessons_ibfk_1` FOREIGN KEY (`courseId`) REFERENCES `courses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lessons`
--

LOCK TABLES `lessons` WRITE;
/*!40000 ALTER TABLE `lessons` DISABLE KEYS */;
INSERT INTO `lessons` VALUES (6,2,'并行计算简介','',2),(9,2,'OpenMP','',2),(10,2,'MPI','',2),(11,3,'Why Parallel Programming?','',3),(12,3,'Parallel Architecture','',3),(13,3,'Parallel Programming Models','',3),(14,3,'Parallel Programming Methodology','',3),(15,3,'Parallel Programming Performance','',3),(16,3,'Shared memory programming and OpenMP','',3),(17,3,'Thread Programming with TBB','',3),(18,3,'Programming Using the Message Passing Paradigm','',3),(19,3,'Introduction to GPGPUs and Cuda Programming Model 2h','',3),(20,3,'Parallel Computing with MapReduce','',3),(21,3,'Experiment','',3),(22,4,'Introduction','',4),(23,4,'Introduction to parallel algorithms and correctness','',4),(24,4,'Parallel Computing Platforms, Memory Systems and Models of Execution','',4),(25,4,'Memory Systems and Introduction to Shared Memory Programming ','',4),(26,4,'Data Parallelism in OpenMP','',4),(27,4,'Data Dependences','',4),(28,4,'Data Locality','',4),(29,4,'Singular Value Decomposition','',4),(30,4,'More Locality and Data Parallelism','',4),(31,4,'Data Parallelism','',4),(32,4,'Breaking Dependences, and Introduction to Task Parallelism ','',4),(33,4,'OpenMP sections and tasks','',4),(34,4,'Midterm Review ','',4),(35,4,'Introduction to Message Passing','',4),(36,4,'MPI Communication','',4),(37,4,'Putting it Together: N-Body','',4),(38,4,'Introduction to GPUs and CUDA','',4),(39,4,'CUDA, cont.','',4),(40,4,'CUDA, cont.','',4),(41,4,'SIMD multimedia extensions','',4),(42,4,'Sparse Algorithms','',4),(43,4,'Parallel Graph Algorithms','',4),(44,4,'Course Retrospective and Future Directions for Parallel Computing','',4),(45,5,'Course Intro','',5),(46,5,'Parallel Architectures and Performance','',5),(47,5,'Details of MPI','',5),(48,5,' Parallel Performance','',5),(49,5,'Matrix Computations: Direct Methods','',5),(50,5,'Matrix Computations: Iterative methods','',5),(51,5,' OpenMP Programming I and II','',5),(52,5,'Fast Methods for N-body Problems','',5),(53,5,' Multigrid and Its Parallel Implementation in CFD Solvers','',5),(54,5,'Domain Decomposition I','',5),(55,5,'Domain Decomposition II','',5),(56,5,'Parallel FFT Algorithms','',5),(57,6,'An introduction to CUDA','',6),(58,6,'Different memory and variable types','',6),(59,6,'Control flow and synchronisation','',6),(60,6,'Warp shuffles, and reduction / scan operations','',6),(61,6,'Libraries and tools','',6),(62,6,'Multiple GPUs, and odds and ends','',6),(63,6,'Tackling a new CUDA application','',6),(64,6,'A case study','',6),(65,6,'Memory optimisations','',6),(66,6,'Profiling and tuning applications','',6),(67,6,'Pascal and CUDA 8.0','',6),(69,1,'Parallel Computing','',1),(70,1,'并行计算——结构·算法·编程 第一章并行计算机系统及结构  第二章 当代并行机系统  第三章 并行计算性能评测','',1),(71,1,'并行算法的设计基础','',1),(72,1,'并行算法的一般设计方法','',1),(73,1,'并行算法的基本设计技术','',1),(74,1,'并行算法的一般设计过程','',1),(75,1,'基本通讯操作','',1),(76,1,'稠密矩阵运算','',1),(77,1,'线性方程组的求解','',1),(78,1,'快速傅里叶变换','',1),(79,1,'并行程序设计基础','',1),(80,1,'共享存储系统编程','',1),(81,1,'分布存储系统并行编程','',1),(82,1,'并行程序设计环境与工具','',1),(83,1,'Architectures Parallel Computing :Architectures· Algorithms Algorithms·Programming','',1),(84,1,'Parallel Computer System Part I : Parallel Computer System Architectures','',1),(85,1,'Parallel Computational Models Part II: Parallel Computational Models','',1),(86,1,'Parallel Programming Part III:Parallel Programming Models','',1),(87,10,'绪论','',10),(88,10,'性能测评','',10),(89,10,'互联网络','',10),(90,10,'对称多处理机系统','',10),(91,10,'大规模并行处理机系统','',10),(92,10,'机群系统','',10),(93,10,'分布共享存储系统','',10),(94,10,'并行机中的通信与延迟问题','',10),(95,11,'并行算法基础','',11),(96,11,'并行算大的基本设计技术','',11),(97,11,'比较器网络上的排序和选择算法','',11),(98,11,'排序和选择的同步算法','',11),(99,11,'排序和选择的异步和分布式算法','',11),(100,11,'并行搜索','',11),(101,11,'数据传输与选路','',11),(102,11,'矩阵运算','',11),(103,11,'数值计算','',11),(104,11,'快速傅里叶变换FFT','',11),(105,11,'图论算法','',11),(106,11,'组合搜索','',11),(107,11,'随机算法','',11),(108,9,'并行编程初步','',9),(109,9,'MPI并行程序设计---参考资料','',9),(110,12,'高性能计算概述','',12),(111,12,'并行程序模型','',12),(112,12,'In-core性能优化与工具','',12),(113,12,'实验环境介绍','',12),(114,12,'OpenMP编程','',12),(115,12,'OpenMP习题课','',12),(116,12,'MPI编程','',12),(117,12,'并行程序性能优化','',12),(118,12,'GPU与加速计算','',12),(119,12,'data-flow-computing','',12),(120,12,'众核编程基础','',12),(121,12,'并行和优化案例','',12),(122,14,'概述（1）','',14),(124,14,'概述（2）','',14),(125,14,'POSIX线程编程基础','',14),(126,14,'Pthreads线程的同步','',14),(127,14,'Pthreads的并行算法编码','',14),(128,14,'并行计算区的计算划分','',14),(129,14,'并行计算区的并发数据访问冲突','',14),(130,14,'MPI并行编程技术概述','',14),(131,14,'MPI程序的资源分配与管理','',14),(132,14,'自定义数据类型和“点到点”的数据交换','',14),(133,14,'进程之间的群通信、单边通信、共享文件访问','',14),(134,14,'并行算法设计','',14),(135,14,'专业化的并行编程模型（1）','',14),(136,14,'专业化的并行编程模型（2）','',14);
/*!40000 ALTER TABLE `lessons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materials`
--

DROP TABLE IF EXISTS `materials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `materials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(1024) NOT NULL,
  `uri` varchar(2048) DEFAULT NULL,
  `lessonId` int(11) DEFAULT NULL,
  `m_type` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `lessonId` (`lessonId`),
  CONSTRAINT `materials_ibfk_1` FOREIGN KEY (`lessonId`) REFERENCES `lessons` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=244 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materials`
--

LOCK TABLES `materials` WRITE;
/*!40000 ALTER TABLE `materials` DISABLE KEYS */;
INSERT INTO `materials` VALUES (84,'lecture2.pdf','course_2/lesson6_material84.pdf',6,'pdf'),(85,'lecture4.pdf','course_2/lesson6_material85.pdf',6,'pdf'),(86,'lecture5.pdf','course_2/lesson6_material86.pdf',6,'pdf'),(87,'lecture9.pdf','course_2/lesson10_material87.pdf',10,'pdf'),(88,'lecture10.pdf','course_2/lesson10_material88.pdf',10,'pdf'),(89,'lecture11.pdf','course_2/lesson10_material89.pdf',10,'pdf'),(90,'lecture12.pdf','course_2/lesson10_material90.pdf',10,'pdf'),(91,'lect5.pdf','course_3/lesson15_material91.pdf',15,'pdf'),(92,'lect10.pdf','course_3/lesson20_material92.pdf',20,'pdf'),(93,'lect11.pdf','course_3/lesson21_material93.pdf',21,'pdf'),(94,'CS4230-L1.pdf','course_4/lesson22_material94.pdf',22,'pdf'),(95,'CS4230-L2.pdf','course_4/lesson23_material95.pdf',23,'pdf'),(96,'CS4230-L3.pdf','course_4/lesson24_material96.pdf',24,'pdf'),(97,'CS4230-L4.pdf','course_4/lesson25_material97.pdf',25,'pdf'),(98,'CS4230-L5.pdf','course_4/lesson26_material98.pdf',26,'pdf'),(99,'CS4230-L6.pdf','course_4/lesson27_material99.pdf',27,'pdf'),(100,'CS4230-L7.pdf','course_4/lesson28_material100.pdf',28,'pdf'),(101,'SVD-L8.pdf','course_4/lesson29_material101.pdf',29,'pdf'),(102,'CS4230-L9.pdf','course_4/lesson30_material102.pdf',30,'pdf'),(103,'CS4230-L10.pdf','course_4/lesson31_material103.pdf',31,'pdf'),(104,'CS4230-L11.pdf','course_4/lesson32_material104.pdf',32,'pdf'),(105,'CS4230-L12.pdf','course_4/lesson33_material105.pdf',33,'pdf'),(106,'2011midterm.pdf','course_4/lesson34_material106.pdf',34,'pdf'),(107,'CS4230-L13.pdf','course_4/lesson35_material107.pdf',35,'pdf'),(108,'CS4230-L14.pdf','course_4/lesson36_material108.pdf',36,'pdf'),(110,'CS4230-L16.pdf','course_4/lesson38_material110.pdf',38,'pdf'),(111,'CS4230-L18.pdf','course_4/lesson40_material111.pdf',40,'pdf'),(112,'CS4230-L19.pdf','course_4/lesson41_material112.pdf',41,'pdf'),(113,'CS4230-L20.pdf','course_4/lesson42_material113.pdf',42,'pdf'),(114,'lecture3-14.pdf','course_5/lesson47_material114.pdf',47,'pdf'),(115,'lecture4-14.pdf','course_5/lesson47_material115.pdf',47,'pdf'),(116,'lecture5-14.pdf','course_5/lesson47_material116.pdf',47,'pdf'),(117,'lecture7-14_1.pdf','course_5/lesson48_material117.pdf',48,'pdf'),(118,'lecture8-14.pdf','course_5/lesson49_material118.pdf',49,'pdf'),(119,'lecture10-14.pdf','course_5/lesson50_material119.pdf',50,'pdf'),(120,'lecture11-14.pdf','course_5/lesson50_material120.pdf',50,'pdf'),(121,'lecture13-14.pdf','course_5/lesson51_material121.pdf',51,'pdf'),(122,'lecture15-14.pdf','course_5/lesson54_material122.pdf',54,'pdf'),(123,'lecture24-14.pdf','course_5/lesson56_material123.pdf',56,'pdf'),(124,'lec1.pdf','course_6/lesson57_material124.pdf',57,'pdf'),(125,'lec2.pdf','course_6/lesson58_material125.pdf',58,'pdf'),(126,'lec3.pdf','course_6/lesson59_material126.pdf',59,'pdf'),(127,'lec4.pdf','course_6/lesson60_material127.pdf',60,'pdf'),(128,'lec5.pdf','course_6/lesson61_material128.pdf',61,'pdf'),(129,'lec6.pdf','course_6/lesson62_material129.pdf',62,'pdf'),(130,'lec7.pdf','course_6/lesson63_material130.pdf',63,'pdf'),(131,'case_study.pdf','course_6/lesson64_material131.pdf',64,'pdf'),(133,'lecture1.pdf','course_2/lesson6_material133.pdf',6,'pdf'),(134,'lecture3.pdf','course_2/lesson6_material134.pdf',6,'pdf'),(135,'lecture6.pdf','course_2/lesson9_material135.pdf',9,'pdf'),(136,'lecture7.pdf','course_2/lesson9_material136.pdf',9,'pdf'),(137,'lecture8.pdf','course_2/lesson9_material137.pdf',9,'pdf'),(138,'lect1.pdf','course_3/lesson11_material138.pdf',11,'pdf'),(139,'lect2.pdf','course_3/lesson12_material139.pdf',12,'pdf'),(140,'lect3.pdf','course_3/lesson13_material140.pdf',13,'pdf'),(141,'lect4.pdf','course_3/lesson14_material141.pdf',14,'pdf'),(142,'lect6.pdf','course_3/lesson16_material142.pdf',16,'pdf'),(143,'lect7.pdf','course_3/lesson17_material143.pdf',17,'pdf'),(144,'lect8.pdf','course_3/lesson18_material144.pdf',18,'pdf'),(145,'lect9.pdf','course_3/lesson19_material145.pdf',19,'pdf'),(146,'CS4230-L15.pdf','course_4/lesson37_material146.pdf',37,'pdf'),(147,'CS4230-L17.pdf','course_4/lesson39_material147.pdf',39,'pdf'),(149,'CS4230-L21.pdf','course_4/lesson44_material149.pdf',44,'pdf'),(150,'CS4230-L20.pdf','course_4/lesson43_material150.pdf',43,'pdf'),(151,'lecture1-14.pdf','course_5/lesson45_material151.pdf',45,'pdf'),(152,'lecture2-14.pdf','course_5/lesson46_material152.pdf',46,'pdf'),(153,'lecture6-14.pdf','course_5/lesson48_material153.pdf',48,'pdf'),(154,'lecture9-14.pdf','course_5/lesson49_material154.pdf',49,'pdf'),(155,'lecture13-14_1.pdf','course_5/lesson52_material155.pdf',52,'pdf'),(156,'lecture14-14.pdf','course_5/lesson53_material156.pdf',53,'pdf'),(157,'parallelMultigrid.pdf','course_5/lesson53_material157.pdf',53,'pdf'),(158,'lecture14a-14.pdf','course_5/lesson53_material158.pdf',53,'pdf'),(159,'memory2.pdf','course_6/lesson65_material159.pdf',65,'pdf'),(160,'Pascal_and_CUDA_8.0.pdf','course_6/lesson67_material160.pdf',67,'pdf'),(161,'profiling2.pdf','course_6/lesson66_material161.pdf',66,'pdf'),(162,'PC0.pdf','course_1/lesson69_material162.pdf',69,'pdf'),(163,'PC1-3.pdf','course_1/lesson70_material163.pdf',70,'pdf'),(164,'PC4.pdf','course_1/lesson71_material164.pdf',71,'pdf'),(165,'PC5.pdf','course_1/lesson72_material165.pdf',72,'pdf'),(166,'PC6.pdf','course_1/lesson73_material166.pdf',73,'pdf'),(167,'PC7.pdf','course_1/lesson74_material167.pdf',74,'pdf'),(168,'PC8.pdf','course_1/lesson75_material168.pdf',75,'pdf'),(169,'PC9.pdf','course_1/lesson76_material169.pdf',76,'pdf'),(170,'PC10.pdf','course_1/lesson77_material170.pdf',77,'pdf'),(171,'PC11.pdf','course_1/lesson78_material171.pdf',78,'pdf'),(172,'PC13.pdf','course_1/lesson80_material172.pdf',80,'pdf'),(173,'PC12.pdf','course_1/lesson79_material173.pdf',79,'pdf'),(174,'PC14.pdf','course_1/lesson81_material174.pdf',81,'pdf'),(175,'PC15.pdf','course_1/lesson82_material175.pdf',82,'pdf'),(176,'outline.pdf','course_1/lesson83_material176.pdf',83,'pdf'),(177,'partI.pdf','course_1/lesson84_material177.pdf',84,'pdf'),(178,'partII.pdf','course_1/lesson85_material178.pdf',85,'pdf'),(179,'partIII.pdf','course_1/lesson86_material179.pdf',86,'pdf'),(180,'lec01-intro.pdf','course_10/lesson87_material180.pdf',87,'pdf'),(181,'lec02-ParaarchTechissue.pdf','course_10/lesson88_material181.pdf',88,'pdf'),(182,'lec03-evaluation.pdf','course_10/lesson88_material182.pdf',88,'pdf'),(183,'lec05-interconnect.pdf','course_10/lesson89_material183.pdf',89,'pdf'),(184,'lec06-interconnect2.pdf','course_10/lesson89_material184.pdf',89,'pdf'),(185,'lec04-performance.pdf','course_10/lesson88_material185.pdf',88,'pdf'),(186,'lec07-SMP.pdf','course_10/lesson90_material186.pdf',90,'pdf'),(187,'lec08-SMP2.pdf','course_10/lesson90_material187.pdf',90,'pdf'),(188,'lec09-SMP3.pdf','course_10/lesson90_material188.pdf',90,'pdf'),(189,'lec10-SMP4.pdf','course_10/lesson90_material189.pdf',90,'pdf'),(190,'lec11-MPP1.pdf','course_10/lesson91_material190.pdf',91,'pdf'),(191,'lec12-CLUSTER.pdf','course_10/lesson92_material191.pdf',92,'pdf'),(192,'lec13-CLUSTER2.pdf','course_10/lesson92_material192.pdf',92,'pdf'),(193,'lec14-Cluster3-DSM1.pdf','course_10/lesson93_material193.pdf',93,'pdf'),(194,'lec15-DSM2.pdf','course_10/lesson93_material194.pdf',93,'pdf'),(195,'lec16-latency.pdf','course_10/lesson94_material195.pdf',94,'pdf'),(196,'ch1.pdf','course_11/lesson95_material196.pdf',95,'pdf'),(197,'ch2.pdf','course_11/lesson96_material197.pdf',96,'pdf'),(198,'ch3.pdf','course_11/lesson97_material198.pdf',97,'pdf'),(199,'ch4.pdf','course_11/lesson98_material199.pdf',98,'pdf'),(200,'ch5.pdf','course_11/lesson99_material200.pdf',99,'pdf'),(201,'ch6.pdf','course_11/lesson100_material201.pdf',100,'pdf'),(202,'ch8.pdf','course_11/lesson101_material202.pdf',101,'pdf'),(203,'ch12.pdf','course_11/lesson102_material203.pdf',102,'pdf'),(204,'ch13.pdf','course_11/lesson103_material204.pdf',103,'pdf'),(205,'ch14.pdf','course_11/lesson104_material205.pdf',104,'pdf'),(206,'ch15.pdf','course_11/lesson105_material206.pdf',105,'pdf'),(207,'ch17.pdf','course_11/lesson106_material207.pdf',106,'pdf'),(208,'ch18.pdf','course_11/lesson107_material208.pdf',107,'pdf'),(209,'MPI编程初步.pdf','course_9/lesson108_material209.pdf',108,'pdf'),(210,'mpi.pdf','course_9/lesson109_material210.pdf',109,'pdf'),(214,'高性能计算概述.pdf','course_12/lesson110_material214.pdf',110,'pdf'),(215,'并行程序模型.pdf','course_12/lesson111_material215.pdf',111,'pdf'),(216,'In-core性能优化与工具Part2.pdf','course_12/lesson112_material216.pdf',112,'pdf'),(217,'In-core性能优化与工具part1.pdf','course_12/lesson112_material217.pdf',112,'pdf'),(218,'实验环境介绍.pdf','course_12/lesson113_material218.pdf',113,'pdf'),(219,'OpenMP编程.pdf','course_12/lesson114_material219.pdf',114,'pdf'),(220,'OpenMP习题课.pdf','course_12/lesson115_material220.pdf',115,'pdf'),(221,'MPI编程1.pdf','course_12/lesson116_material221.pdf',116,'pdf'),(222,'MPI编程2.pdf','course_12/lesson116_material222.pdf',116,'pdf'),(223,'Part1-并行程序性能优化.pdf','course_12/lesson117_material223.pdf',117,'pdf'),(224,'Part2-并行程序性能优化.pdf','course_12/lesson117_material224.pdf',117,'pdf'),(225,'Part3-并行程序性能优化.pdf','course_12/lesson117_material225.pdf',117,'pdf'),(226,'GPU与加速计算.pdf','course_12/lesson118_material226.pdf',118,'pdf'),(227,'data-flow-computing.pdf','course_12/lesson119_material227.pdf',119,'pdf'),(228,'众核编程基础.pdf','course_12/lesson120_material228.pdf',120,'pdf'),(229,'并行和优化案例.pdf','course_12/lesson121_material229.pdf',121,'pdf'),(230,'2016_1.pdf','course_14/lesson122_material230.pdf',122,'pdf'),(231,'2016_2.pdf','course_14/lesson124_material231.pdf',124,'pdf'),(232,'2016_3.pdf','course_14/lesson125_material232.pdf',125,'pdf'),(233,'2016_4.pdf','course_14/lesson126_material233.pdf',126,'pdf'),(234,'2016_5.pdf','course_14/lesson127_material234.pdf',127,'pdf'),(235,'2016_6.pdf','course_14/lesson128_material235.pdf',128,'pdf'),(236,'2016_7.pdf','course_14/lesson129_material236.pdf',129,'pdf'),(237,'2016_8.pdf','course_14/lesson130_material237.pdf',130,'pdf'),(238,'2016_9.pdf','course_14/lesson131_material238.pdf',131,'pdf'),(239,'2016_10.pdf','course_14/lesson132_material239.pdf',132,'pdf'),(240,'2016_11.pdf','course_14/lesson133_material240.pdf',133,'pdf'),(241,'2016_12.pdf','course_14/lesson134_material241.pdf',134,'pdf'),(242,'2016_13.pdf','course_14/lesson135_material242.pdf',135,'pdf'),(243,'2016_14.pdf','course_14/lesson136_material243.pdf',136,'pdf');
/*!40000 ALTER TABLE `materials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paper_course`
--

DROP TABLE IF EXISTS `paper_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paper_course` (
  `course_id` int(11) NOT NULL DEFAULT '0',
  `paper_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`course_id`,`paper_id`),
  KEY `course_id` (`course_id`),
  KEY `paper_id` (`paper_id`),
  CONSTRAINT `paper_course_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  CONSTRAINT `paper_course_ibfk_2` FOREIGN KEY (`paper_id`) REFERENCES `papers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paper_course`
--

LOCK TABLES `paper_course` WRITE;
/*!40000 ALTER TABLE `paper_course` DISABLE KEYS */;
INSERT INTO `paper_course` VALUES (1,1),(1,2),(1,3);
/*!40000 ALTER TABLE `paper_course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paper_question`
--

DROP TABLE IF EXISTS `paper_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paper_question` (
  `question_id` int(11) NOT NULL DEFAULT '0',
  `paper_id` int(11) NOT NULL DEFAULT '0',
  `point` int(11) NOT NULL,
  PRIMARY KEY (`question_id`,`paper_id`),
  KEY `question_id` (`question_id`),
  KEY `paper_id` (`paper_id`),
  CONSTRAINT `paper_question_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
  CONSTRAINT `paper_question_ibfk_2` FOREIGN KEY (`paper_id`) REFERENCES `papers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paper_question`
--

LOCK TABLES `paper_question` WRITE;
/*!40000 ALTER TABLE `paper_question` DISABLE KEYS */;
INSERT INTO `paper_question` VALUES (8,1,20);
/*!40000 ALTER TABLE `paper_question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `papers`
--

DROP TABLE IF EXISTS `papers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `papers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `about` varchar(128) NOT NULL,
  `courseId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `courseId` (`courseId`),
  CONSTRAINT `papers_ibfk_1` FOREIGN KEY (`courseId`) REFERENCES `courses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `papers`
--

LOCK TABLES `papers` WRITE;
/*!40000 ALTER TABLE `papers` DISABLE KEYS */;
INSERT INTO `papers` VALUES (1,'测验1','这是测验1',1),(2,'测验2','这是测验2',1),(3,'测验3','这是测验3',1);
/*!40000 ALTER TABLE `papers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(1024) NOT NULL,
  `topicID` int(11) DEFAULT NULL,
  `userID` int(11) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `topicID` (`topicID`),
  KEY `userID` (`userID`),
  CONSTRAINT `post_ibfk_1` FOREIGN KEY (`topicID`) REFERENCES `topics` (`id`),
  CONSTRAINT `post_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post`
--

LOCK TABLES `post` WRITE;
/*!40000 ALTER TABLE `post` DISABLE KEYS */;
INSERT INTO `post` VALUES (1,'内容不错',1,1,'2016-09-10 00:00:00'),(2,'坐等下篇',1,1,'2016-10-10 00:00:00'),(3,'1212',1,1,'2016-10-15 17:07:45'),(4,'@<a href=\"/user/1/\" class=\"mention\">root</a>  测试一下评论',1,1,'2016-10-15 19:36:58'),(5,'新的评论啊',1,1,'2016-10-15 19:38:39'),(6,'新的话题啊',1,1,'2016-10-15 19:40:29'),(7,'测试评论功能',1,1,'2016-10-15 19:41:35'),(8,'8 评论啊',1,1,'2016-10-15 19:42:07'),(9,'第 9 条 评论',1,1,'2016-10-15 19:42:46'),(10,'第 10 评论',1,1,'2016-10-15 19:44:04'),(19,'1',2,1,'2016-10-15 19:57:59'),(20,'2',2,1,'2016-10-15 19:58:02'),(21,'2',2,1,'2016-10-15 19:58:04'),(22,'3',2,1,'2016-10-15 19:58:08'),(23,'@<a href=\"/user/1/\" class=\"mention\">root</a> ',2,1,'2016-10-15 19:59:17'),(24,'1212',2,1,'2016-10-15 20:00:38'),(25,'433',2,1,'2016-10-15 20:00:49'),(26,'12',2,1,'2016-10-15 20:01:03'),(27,'新的评论测死',2,1,'2016-10-15 20:02:39'),(42,'1',3,1,'2016-10-15 20:28:19'),(43,'2',3,1,'2016-10-15 20:28:22'),(44,'3',3,1,'2016-10-15 20:28:24'),(45,'4',3,1,'2016-10-15 20:29:13'),(46,'4',3,1,'2016-10-15 20:29:17'),(47,'6',3,1,'2016-10-15 20:30:47'),(48,'7',3,1,'2016-10-15 20:30:55'),(49,'11',1,1,'2016-10-15 20:31:11'),(50,'1',4,1,'2016-10-15 20:32:54'),(51,'@<a href=\"/user/1/\" class=\"mention\">root</a> 2',4,1,'2016-10-15 20:35:37'),(52,'@<a href=\"/user/1/\" class=\"mention\">root</a> 3',4,1,'2016-10-15 20:36:23'),(53,'@<a href=\"/user/1/\" class=\"mention\">root</a> 4',4,1,'2016-10-15 20:36:35'),(54,'5',4,1,'2016-10-15 20:44:03'),(55,'212121  @<a href=\"/user/1/\" class=\"mention\">root</a> @<a href=\"/user/1/\" class=\"mention\">root</a> ',4,1,'2016-10-15 20:45:05'),(56,'@<a href=\"/user/1/\" class=\"mention\">root</a> 22',1,1,'2016-10-15 22:56:07'),(57,'1',5,1,'2016-10-16 16:24:45'),(58,'2',5,1,'2016-10-16 17:16:02'),(59,'12',6,1,'2016-10-16 22:50:36'),(60,'2',6,1,'2016-10-16 22:50:39'),(61,'新技能 GET',6,4,'2016-10-17 12:01:27'),(62,'乱码了',5,4,'2016-10-17 14:13:22'),(63,'评论测试',6,4,'2016-10-17 14:15:02'),(64,'我来评价',8,1,'2016-10-19 15:19:00'),(65,'@<a href=\"/user/1/\" class=\"mention\">root</a> 评价功能 bug 修复',8,3,'2016-10-22 11:12:51'),(66,'\\[ x = y_1^i + 1 \\]',12,3,'2017-01-09 14:31:06'),(67,'\\[` x = y_1^i + 1`\\]',12,3,'2017-01-09 14:31:32');
/*!40000 ALTER TABLE `post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `programs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `detail` text NOT NULL,
  `difficulty` int(11) DEFAULT NULL,
  `acceptedNum` int(11) DEFAULT NULL,
  `submitNum` int(11) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `programs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs`
--

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;
INSERT INTO `programs` VALUES (1,'编写Pthreads程序','编写Pthreads程序，求小于2n的素数。\r\n\r\na)	输入：整数n，10\\<n\\<48。\r\n\r\nb)	输出：二进制文件。每个素数用一个int64_t型的整数表示，找到的全部素数按照从小到大顺序存储在输出文件中。\r\n',0,0,0,'2016-12-29 23:53:11',3),(2,'编写MPI程序','编写MPI程序，求小于2n的素数。\r\n\r\na)	输入：整数n，10\\<n\\<48。\r\n\r\nb)	输出：二进制文件。每个素数用一个int64_t型的整数表示，找到的全部素数按照从小到大顺序存储在输出文件中。\r\n',0,0,0,'2016-12-29 23:53:40',3),(3,'计算π的近似值','公式![](/static/upload/md_images/20161229235552.png)可用于计算π的近似值。编写串行程序、Pthreads程序、和MPI程序实现该公式，分别计算π的近似值。\r\n\r\na)	输入：整数k和p，10\\<k\\<48。n=2k表示计算精度，p是并行执行时处理器的数量。\r\n\r\nb)	输出：每个版本分别以科学表示法输出所计算的π。\r\n',0,0,0,'2016-12-29 23:56:26',3),(4,'计算两个矩阵的乘积','计算两个矩阵A和B的乘积A×B，其中A是m×n的单精度浮点数矩阵、B是n×k的单精度浮点数矩阵。\r\n\r\na)	输入：m、n、k、fa、fb、of。m、n、k是三个正整数，分别表示矩阵A和B的行数、列数。fa和fb是两个二进制输入文件，fa按行优先顺序存储A的元素值，fb按行优先顺序存储B的元素值；of是输出文件的名称。\r\n\r\nb)	输出：名为of的二进制文件，按行优先顺序存储结果矩阵的元素。\r\n\r\n',0,0,0,'2016-12-29 23:58:14',3),(5,'整型数组排序','对长度为2n的整型数组排序。原始数组的每个元素类型为int32_t，以二进制存储在数据文件data.in中。\r\n\r\na)	输入：n。\r\n\r\nb)	输出：对data.in中前2n个元素从小到大排序，并将排序结果以二进制存储在文件data.out中。\r\n',0,0,0,'2016-12-29 23:58:44',3),(6,'求粒子状态','在某个粒子系统中共有2n个粒子，粒子之间的互相吸引力导致其状态不断变化。为简化问题，我们将任意两个粒子b1和b2之间的吸引力用公式![](/static/upload/md_images/20161230000108.png)表示，其中m1、m2分别是b1和b2的质量，→┬r_12是b1和b2之间的矢量距离；粒子b的移动速度用矢量表示f ⃗/m表示，其中f ⃗、m分别是b的受力和质量。计算经过t个时间步后，该粒子系统的状态。粒子的原始状态存储在二进制文件data.in中，每个粒子的状态占用4个双精度浮点数，依次是质量、x轴坐标、y轴坐标、z轴坐标。\r\n\r\na)	输入：n，t。n表示粒子系统中共有2n个粒子，t是模拟计算的时间步数量。\r\n\r\nb)	输出：经过t步后各个粒子的状态，存储在二进制文件data.out中data.in。粒子在输出文件中的存储顺序与输入文件的一致，每个粒子的状态占用4个双精度浮点数，依次是质量、x轴坐标、y轴坐标、z轴坐标。\r\n',0,0,0,'2016-12-30 00:02:31',3),(7,'统计图顶点的度数','给定图G=\\<V, E\\>的全部边，统计其中各顶点的度数。假设G是无向图，其顶点从0开始顺序编号。\r\n\r\na)	输入：graph.mtx。二进制文件名，其中每条记录表示G的一条边，由两个 int32_t型的整数组成，分别是端点的序号。\r\n\r\nb)	输出：graph.deg。与输入文件相同前缀的二进制文件名，存储G中各个顶点的度数。每个顶点的度数用一个int32_t型的整数表示，各顶点度数的存储顺序与其编号顺序一致。\r\n',0,0,0,'2016-12-30 00:03:11',3),(8,'浮点数数组排序','对长度为2n的浮点数数组排序。原始数组的每个元素类型为双精度浮点数，以二进制存储在数据文件data.in中。\r\n\r\na)	输入：n。\r\n\r\nb)	输出：对data.in中前2n个元素从小到大排序，并将排序结果以二进制存储在文件data.out中。\r\n',0,0,0,'2016-12-30 00:03:33',3);
/*!40000 ALTER TABLE `programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `progress`
--

DROP TABLE IF EXISTS `progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `progress` (
  `user_id` int(11) NOT NULL,
  `knowledge_id` int(11) NOT NULL,
  `cur_progress` int(11) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  PRIMARY KEY (`user_id`,`knowledge_id`),
  KEY `knowledge_id` (`knowledge_id`),
  CONSTRAINT `progress_ibfk_1` FOREIGN KEY (`knowledge_id`) REFERENCES `knowledges` (`id`),
  CONSTRAINT `progress_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `progress`
--

LOCK TABLES `progress` WRITE;
/*!40000 ALTER TABLE `progress` DISABLE KEYS */;
INSERT INTO `progress` VALUES (1,4,1,'0000-00-00 00:00:00'),(2,4,6,'0000-00-00 00:00:00'),(3,4,1,'2017-02-23 15:15:39'),(5,4,2,'0000-00-00 00:00:00'),(10,4,0,'0000-00-00 00:00:00'),(12,4,0,'0000-00-00 00:00:00'),(13,4,0,'0000-00-00 00:00:00');
/*!40000 ALTER TABLE `progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrcode`
--

DROP TABLE IF EXISTS `qrcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrcode` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `end_time` datetime NOT NULL,
  `course_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `qrcode_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrcode`
--

LOCK TABLES `qrcode` WRITE;
/*!40000 ALTER TABLE `qrcode` DISABLE KEYS */;
INSERT INTO `qrcode` VALUES (1,'2017-01-04 13:45:38',1);
/*!40000 ALTER TABLE `qrcode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_classifies`
--

DROP TABLE IF EXISTS `question_classifies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `question_classifies` (
  `question_id` int(11) NOT NULL DEFAULT '0',
  `classify_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`question_id`,`classify_id`),
  KEY `question_id` (`question_id`),
  KEY `classify_id` (`classify_id`),
  CONSTRAINT `question_classifies_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
  CONSTRAINT `question_classifies_ibfk_2` FOREIGN KEY (`classify_id`) REFERENCES `classifies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question_classifies`
--

LOCK TABLES `question_classifies` WRITE;
/*!40000 ALTER TABLE `question_classifies` DISABLE KEYS */;
INSERT INTO `question_classifies` VALUES (8,4),(13,4),(14,4),(15,4),(16,4),(17,4),(18,5),(19,5),(20,5),(21,5),(22,5),(23,5),(24,5),(25,5),(26,5),(27,5),(28,5),(29,5),(30,5),(31,5),(32,5),(33,5),(34,5),(35,5),(36,5),(37,5),(38,5),(39,5),(40,5),(41,5),(42,5),(43,5),(44,5),(45,5),(46,5),(47,5),(48,5),(49,5),(50,5),(51,5),(52,5),(53,5),(54,5),(55,5),(56,5),(57,5),(58,5),(59,5),(60,5),(61,5),(62,5),(63,5),(64,5),(65,5),(66,5),(67,5),(68,5),(69,5),(70,5),(71,5),(72,5),(73,5),(74,5),(75,5),(76,5),(77,5),(78,5),(79,5),(80,5),(81,5),(82,5),(83,5),(84,5),(85,5),(86,5),(87,5),(88,5),(89,5),(90,5),(91,5),(92,5),(93,5),(94,5),(95,5),(96,5),(97,5),(98,5),(99,5),(100,5),(101,5),(102,5),(103,5),(104,5),(105,5),(106,5),(107,5),(108,5),(109,5),(110,5),(111,5),(112,5),(113,5),(114,5),(115,5),(116,5),(117,5),(118,5),(119,5),(120,5),(121,5),(122,5),(123,5),(124,5),(125,5),(126,5),(127,5),(128,5),(129,5),(130,5),(131,5),(132,5),(133,5),(134,5),(135,5),(136,5),(137,5),(138,5),(139,5),(140,5),(141,5),(142,5),(143,5),(144,5),(145,5),(146,5),(147,5),(148,5),(149,5),(150,5),(151,5),(152,5),(153,5),(154,5),(155,5),(156,5),(157,5),(158,5),(159,5),(160,5),(161,5),(162,5),(163,5),(164,5),(165,5),(166,5),(167,5),(168,5),(169,5),(170,5),(171,5),(172,5),(173,5),(174,5),(175,5),(176,5),(177,5),(178,5),(179,5),(180,5),(181,5),(182,5),(183,5),(184,5),(185,5),(186,5),(187,5),(188,5),(189,5),(190,5),(191,5),(192,5),(193,5),(194,5),(195,5),(196,5),(197,5),(198,5),(199,5),(200,5),(201,5),(202,5),(203,5),(204,5),(205,5),(206,5),(207,5),(208,5),(209,5),(210,5),(211,5),(212,5),(213,5),(214,5),(215,5),(216,5),(217,5),(218,5),(219,5),(220,5),(221,5),(222,5),(223,5),(224,5),(225,5),(226,5),(227,5),(228,5),(229,5),(230,5),(231,5),(232,5),(233,5),(234,5),(235,5),(236,5),(237,5),(238,5),(239,5),(240,5),(241,5),(242,5),(243,5),(244,5),(245,5),(246,5),(247,5),(248,5),(249,5),(250,5),(251,5),(252,5),(253,5),(254,5),(255,5),(256,5),(257,5),(258,5),(259,5),(260,5),(261,5),(262,5),(263,5),(264,5),(265,5),(266,5),(267,5),(268,5),(269,5),(270,5),(271,5),(272,5),(273,5),(274,5),(275,5),(276,5),(277,5),(278,5),(279,5),(280,5),(281,5),(282,5),(283,5),(284,5),(285,5),(286,5),(287,5),(288,5),(289,5),(290,5),(291,5),(292,5),(293,5),(294,5),(756,7),(757,7),(758,7),(759,7),(760,7),(761,7),(762,7),(763,7),(764,7),(765,7),(766,7),(767,7),(768,7),(769,7),(770,7);
/*!40000 ALTER TABLE `question_classifies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) NOT NULL,
  `content` varchar(2048) NOT NULL,
  `solution` varchar(512) NOT NULL,
  `analysis` varchar(1024) DEFAULT '',
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `course_id` (`user_id`),
  CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=771 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (8,1,'{\"0\":\"单指令流单数据流（Single Instruction stream Single Data stream, SISD\",\"1\":\"单指令流多数据流（Single Instruction stream Multiple Data stream, SIMD\",\"2\":\"多指令流单数据流（Multiple Instruction stream Single Data stream, MISD\",\"3\":\"多指令流多数据流（Multiple Instruction stream Multiple Data stream, MISD\",\"title\":\"Flynn根据指令流和数据流的不同组织方式，把计算机系统的结构分为以下四类：\\n\\n\",\"len\":4}','A;B;C;D','对并行计算机的分类有多种方法，其中最著名的是1966年由M.J.Flynn提出的分类法，称为Flynn分类法。Flynn分类法是从计算机的运行机制进行分类的。首先作如下定义：\r\n\r\n* 指令流（instruction stream）：机器执行的指令序列；\r\n* 数据流（data stream）：由指令流调用的数据序列，包括输入数据和中间结果。\r\n\r\nFlynn根据指令流和数据流的不同组织方式，把计算机系统的结构分为以下四类：\r\n\r\n* 单指令流单数据流（Single Instruction stream Single Data stream, SISD）；\r\n* 单指令流多数据流（Single Instruction stream Multiple Data stream, SIMD）；\r\n* 多指令流单数据流（Multiple Instruction stream Single Data stream, MISD）；\r\n* 多指令流多数据流（Multiple Instruction stream Multiple Data stream, MISD）。\r\n',3),(13,0,'{\"0\":\"(n/8+4) tc＋4tw, (n/8+4) tc＋4tw\",\"1\":\"(n/8+4) tc＋4tw, (n/8+4) tc＋3tw\",\"2\":\"(n/8+4) tc＋3tw, (n/8+4) tc＋4tw\",\"3\":\"(n/8+4) tc＋3tw, (n/8+4) tc＋3tw\",\"title\":\"将n个数相加，假设一个人相加两个数需要的时间为tc，那么一个人完成相加n个数需要(n-1)\\\\*tc。\\n\\n若由8个技能完全相同的人计算这n个数的和，且8|n，相邻的两个人传送一个数需时间tw，在下列两种情况下：\\n\\n1. 8个人坐成一圈。\\n2. 8个人坐成一行。\\n\\n完成n个数的相加各需多长时间？\",\"len\":4}','A',' 一个人完成n个数的相加需要的时间为(n-1)*tc \r\n \r\n 1. 若8个人坐成一圈，每个人完成n/8个数需要的时间为(n/8-1)\\*tc，从相邻的两个人同时开始向两个方向传送数据并相加，三次传送与相加需时间3(tc+tw)，最后，两个人再进行一次传送及一次计算就得到了最终结果。总的开销为(n/8-1)\\*tc＋ 3(tc+tw)＋(tc+tw)＝(n/8+4) tc＋4tw \r\n2. 同理，若8个人坐成一行，每个人完成n/8个数需要的时间为(n/8-1)\\*tc，从最远的两个人同时开始向中间方向传送数据并相加，最后，两个人再进行一次传送及一次计算就得到了最终结果。总的开销也为(n/8+4) tc＋4tw ',3),(14,4,'并行计算机的自动编程：设计一个并行化编译器，使用户的串行程序通过并行化编译器编译，直接可在并行机上运行。到目前为此，这种编译器**已经存在**，并广泛应用于许多学科中。\r\n','0','并行计算机的自动编程：可否设计一个并行化编译器，使用户的串行程序通过并行化编译器编译，直接可在并行机上运行。到目前为此，这种编译器还不存在，而仅有一些半自动并行化编译器。\r\n',3),(15,1,'{\"0\":\"计算密集型（Compute-Intensive）\",\"1\":\"数据密集型 (Data-Intensive)\",\"2\":\"文本密集型 (Text-Intensive)\",\"3\":\"网络密集型 (Network-Intensive)\",\"title\":\"并行计算的应用可概括为以下哪些方面\",\"len\":4}','A;B;D','科学与工程计算对并行计算的需求是十分广泛的，但所有的应用可概括为三个方面：\r\n\r\n* 计算密集型（Compute-Intensive）：这一类型的应用问题主要集中在大型科学工程计算与数值模拟（气象预报、地球物理勘探等）\r\n* 数据密集型 (Data-Intensive)：Internet的发展，为我们提供了大量的数据资源，但有效地利用这些资源，需要进行大量地处理，且对计算机的要求也相当高，这些应用包括数字图书馆、数据仓库、数据挖掘、计算可视化。\r\n* 网络密集型 (Network-Intensive)：通过网络进行远距离信息交互，来完成用传统方法不同的一些应用问题。如协同工作、遥控与远程医疗诊断等',3),(16,4,'SIMD中通常包含大量处理单元PE，而控制部件只有一个。控制部件广播一条指令，所有的处理单元同时执行这条指令，但不同的处理单元操作的数据可能不同。','1','SIMD中通常包含大量处理单元PE，而控制部件只有一个。控制部件广播一条指令，所有的处理单元同时执行这条指令，但不同的处理单元操作的数据可能不同。',3),(17,4,'并行向量处理机的最大特点是其中的各处理器完全平等，无主从之分。所有的处理器都可以访问任何存储单元和I/O设备。','0','对称多处理机 对称多处理机的最大特点是其中的各处理器完全平等，无主从之分。所有的处理器都可以访问任何存储单元和I/O设备。存储器一般使用共享存储器，只有一个地址空间。',3),(18,4,'为了维持一定的并行效率（介于 0 与 1 之间），当处理器 P 增大时，需要相应地增大问题规模 W 的值，由此定 义函数 fE(p)为问题规模 W 随处理器 P 变化的函数，称此函数为等效率函数。','1','',3),(19,4,'用户态线程和核心态线程都由操作系统直接调度。','0','',3),(20,4,'在广播通信中，单个进程传递相同的数据给所有的进程。','1','',3),(21,4,'while 循环语句是忙等待的一个例子。','1','',3),(22,4,'一个好的并行算法要既能很好地匹配并行计算机硬件体系结构的特点又能反映问题内在并行性。','1','',3),(23,4,'如果一个线程在临界区中执行代码，其他线程需要被排序在临界区外。','1','',3),(24,4,'计算机视觉不属于英特尔集成性能函数库(IPP)所涵盖的领域。','0','',3),(25,4,'控制单元负责决定应该执行程序中的哪些指令，而 ALU 负责执行指令核已经成为中央处理器或者 CPU 的代名词。','1','',3),(26,4,'OpenMP 是用于共享内存并行系统的多线程程序设计的一套指导性的编译处理方案(Compiler Directive)，也可以将其扩展到用于分布式内存的集群系统。','1','',3),(27,4,'在共享内存系统中，每个处理器有自己私有的内存空间，处理器-内存对之间通过互连网络相互通信。','0','',3),(28,4,'在 Amdahl 定律中，以 f 表示串行分量的比例，随着处理器数目的无限增大，并行系统所能够达到的加速上限是S=1/f。','1','',3),(29,4,'通过继续增快集成电路的速度来提高处理器性能是可行的。','0','',3),(30,4,'阻塞通信的功能都可以用非阻塞通信的方式实现。','1','',3),(31,4,'ALU 负责决定应该执行程序中的哪些指令，而控制单元负责执行指令。','0','',3),(32,4,'OpenMP 对同一个临界区不应当混合使用不同的互斥机制。','1','',3),(33,4,'MPI 中发送语句用整型，接收语句用实型可以匹配。','0','',3),(34,4,'在有效编程下，超线程性能要高于多核性能。','0','',3),(35,4,'MPI_COMM_RANK 是 MPI 的一个基本函数，它用于确定进程总数。','0','',3),(36,4,'并行计算中的并行性指问题中具有可在同一时刻发生的两个或者多个运算或者操作的特性。','0','',3),(37,4,'英特尔线程检查器能够找出线程间的工作不平衡。','0','',3),(38,4,'如果 MPI 程序中的某条输出语句在每一个进程都执行，则从标准输出上看，不同进程对该语句的输出在 顺序上是随机的。','1','',3),(39,4,'依赖于 MPI 提供的缓冲机制是安全的。','0','',3),(40,4,'利用矩阵向量相乘的方式进行离散傅立叶变换，计算复杂度是 O(n3),而快速傅里叶变换的时间复杂度是 O(nlogn)。','0','',3),(41,4,'对于一个给定的应用，并行算法相比于串行算法的性能提升是（1- T 并行执行时间/T 串行执行时间）','0','',3),(42,4,'一般来说，对高速缓冲存储器的访问时间比其他存储区域的访问时间短','1','',3),(43,4,'组通信需要该组内所有的进程都参加?。','1','',3),(44,4,'在细粒度多线程中，处理器在每条指令执行完后切换线程，从而跳过被阻塞的线程。','1','',3),(45,4,'英特尔 Parallel Inspector 采用动态技术，不需要特殊的检查工具或者编译','1','',3),(46,4,'虚拟进程数要小于实际的处理器的个数。','0','',3),(47,4,'Vtune 性能分析器能够分析程序中的代码错误并指出错误代码的位置。','0','',3),(48,4,'Linpack 是国际上最流行的用于测试高性能计算机系统浮点性能的 benchmark。它采用高斯消元法求解一 元 N 次稠密线性代数方程组，也即采用正交三角分解法（LU 分解）。','0','',3),(49,4,'在并行程序设计中，局部变量指的是单个函数的私有变量。','0','',3),(50,4,'忙等待是保护临界区的唯一办法。','0','',3),(51,4,'向量处理器与图形处理器单元一般划分在 SIMD 系统里。','1','',3),(52,4,'如果一个线程在临界区中执行代码，其他线程需要被排序在临界区外。','1','',3),(53,4,'单处理器性能大幅度提升的主要原因之一是日益增加的集成电路晶体管密度。','1','',3),(54,4,'依赖于 MPI 提供的缓冲机制是安全的。','0','',3),(55,4,'OS timer service 是 Vtune 性能分析器的基于时间的采样。','1','',3),(56,4,'利用虚拟存储器，使得主存可以作为辅存的缓存。','1','',3),(57,4,'在分布式内存系统中，各个核能够共享访问计算机的内存，理论上每个核能够读、写内存的所有','0','',3),(58,4,'在实现指令级并行中，流水线是指将功能单元分阶段安排。（','0','',3),(59,4,'Vtune 性能分析器不搜集执行代码在内存中的地址信息。','0','',3),(60,4,'将串行程序并行化，并行化的代码区域越多，程序的整体性能越好。','0','',3),(61,4,'多核 CPU 中也可以使用超线程技术。','1','',3),(62,4,'在大多数系统中，进程间的切换比线程间的切换更快。','0','',3),(63,4,'在共享内存系统中，每个处理器有自己私有的内存空间，处理器-内存对之间通过互连网络相互 通信。','0','',3),(64,4,'英特尔线程检查器能够找出线程间的工作不平衡。','0','',3),(65,4,'内存系统由多个内存“体”组成，每个内存体能够独立访问。','1','',3),(66,4,'阻塞通信的功能都可以用非阻塞通信的方式实现?。','1','',3),(67,4,'一个好的并行算法要既能很好地匹配并行计算机硬件体系结构的特点又能反映问题内在并行性','1','',3),(68,4,'组通信调用只能实现通信功能 。','0','',3),(69,4,'中央处理单元分为控制单元和算术逻辑单元。','1','',3),(70,4,'在并行程序设计中，局部变量指的是单个函数的私有变量。','0','',3),(71,4,'非阻塞通信的功能都可以用阻塞通信的方式实现?。','0','',3),(72,4,'Cache 3C 失效中的强制性失效不受 Cache 容量的影响。','1','',3),(73,4,'MPI 主从模式的并行程序可以为 SPMD 形式。','1','',3),(74,4,'在实现指令级并行中，流水线是指将功能单元分阶段安排。','0','',3),(75,4,'多线程程序中，一个线程可以与同进程中的其它线程共享数据，因此当一个线程对全局变量 X赋值 0（即执行 x=0）之后，其它线程立刻读取 X，其值必为 0。','0','',3),(76,4,'在共享内存系统中，每个核拥有自己的私有内存，核之间的通信是显式的，必须使用类似于网络 中发送消息的机制。','0','',3),(77,4,'不管 OpenMP 语句以何种形式实现，修改同一变量的不同语句都将视为属于同一个临界区。','1','',3),(78,4,'在机群系统的并行应用中，一个进程先执行发送操作，另一个进程先执行相应的接收操作，是安 全的发送和接收序列。','1','',3),(79,4,'将串行程序并行化，并行化的代码区域越多，程序的整体性能越好。','0','',3),(80,4,'英特尔 Parallel Inspector 采用动态技术，不需要特殊的检查工具或者编译','1','',3),(81,4,'IPO 对于循环内包含调用的程序可以极大地提高其性能。','1','',3),(82,4,'操作系统是一种用来管理计算机的软件和硬件资源的主要软件。','1','',3),(83,4,'单处理器性能大幅度提升的主要原因之一是日益增加的集成电路晶体管密度。','1','',3),(84,4,'ALU 负责决定应该执行程序中的哪些指令，而控制单元负责执行指令。','0','',3),(85,4,'在共享内存系统中，每个核拥有自己的私有内存，核之间的通信是显式的，必须使用类似于网络 中发送消息的机制。','0','',3),(86,4,'MPI 使用的是所谓的“推”（Push） 通信机制','1','',3),(87,4,'一块内存空间，包括可执行代码，一个用来跟踪执行函数的调用栈、一个堆，以及一些其他内存','1','',3),(88,4,'一个并行程序的并行效率越高，它的浮点性能就越高。','0','',3),(89,4,'MPI 中发送语句用整型，接收语句用实型可以匹配。','0','',3),(90,4,'在大多数系统中，进程间的切换比线程间的切换更快。','0','',3),(91,4,'操作系统是一种用来管理计算机的软件和硬件资源的主要软件。','1','',3),(92,4,'有依赖关系的语句中一定有语句会有序地写或更新变量。','1','',3),(93,4,'如果一个线程在临界区中执行代码，其他线程需要被排序在临界区外。','1','',3),(94,4,'OpenMP 只能并行化 for 循环，不能并行化 while 和 do-while 循环。','1','',3),(95,4,'内存系统由多个内存“体”组成，每个内存体能够独立访问。','1','',3),(96,4,'用户态线程和核心态线程都由操作系统直接调度。','0','',3),(97,4,'并行算法求解问题只要保证与相应的串行算法一致的数据依赖，则其求解的结果与串行算法相同。','0','',3),(98,4,'依赖于 MPI 提供的缓冲机制是安全的。','0','',3),(99,4,'一个并行程序的并行效率越高，它的浮点性能就越高。','0','',3),(100,4,'向量处理器与图形处理器单元一般划分在 SIMD 系统里。','1','',3),(101,4,'在并行程序设计中，局部变量指的是单个函数的私有变量。','0','',3),(102,4,'依赖于 MPI 提供的缓冲机制是安全的。','0','',3),(103,4,'大多数系统中，默认状态下，一个进程的内存块是公有的。','0','',3),(104,4,'在分布式内存和共享内存系统，所有进程/线程都能够访问 stdout 和 stder','1','',3),(105,4,'OS timer service 是 Vtune 性能分析器的基于时间的采样。','1','',3),(106,4,'所有的向量数据类型都可以定义为结构数据类型。','1','',3),(107,4,'内存系统由多个内存“体”组成，每个内存体能够独立访问。','1','',3),(108,4,'非阻塞发送语句可以用阻塞接收语句来接收。','1','',3),(109,4,'在写回 Cache 中，数据不是立即更新到主存中，而是将发生数据更新的高速缓存行标记为脏。','1','',3),(110,4,'当一个 for 循环存在循环依赖时不能被并行化。','1','',3),(111,0,'{\"len\": 4, \"1\": \"single\", \"title\": \"指定代码只能由线程组中的一个线程执行的 OpenMP 编译制导命令是\", \"3\": \"atomic\", \"0\": \"master\", \"2\": \"critical\"}','B','',3),(112,0,'{\"len\": 4, \"1\": \"Store-conditional 指令和普通的 Store 指令没有差别，只是多核处理器上的特别叫法。\", \"title\": \"下面关于 Load-link 和 Store-conditional 指令的说法，正确的是\", \"3\": \"Load-link 指令有可能失败。\", \"0\": \"Load-link 和普通的 Load 指令没有差别，只是多核处理器上的特别叫法。\", \"2\": \"Load-link 和 Store-conditional 指令可以用于实现同步原语。\"}','C','',3),(113,0,'{\"len\": 4, \"1\": \"速率\", \"title\": \"链路的（ ）是指它传输数据的速度。\", \"3\": \"延迟带宽积\", \"0\": \"带宽\", \"2\": \"延迟\"}','A','',3),(114,0,'{\"len\": 4, \"1\": \"barrier\", \"title\": \"在并行域当中，在一段代码临界区之前只有一个线程进入，是使用什么关键字\", \"3\": \"master\", \"0\": \"critical\", \"2\": \"atomic\"}','A','',3),(115,0,'{\"len\": 4, \"1\": \"M/(0.85+0.015M)\", \"title\": \"假设有一个计算问题，其中串行计算量占 15%。为实现并行计算，需要增加 1.5%的计算量，这部分计算量是不能并行执行的，并且与所使用处理器/执行内核的数量无关。此外，每个处理器执行内核在执行并行计算任务的过程中，还需要执行为所承担的并行任务执行一定的额外操作。这些额外操作的计算量是所承担并行任务量 的 0.1%。请问，在一个有 M 颗处理器/执行内核的计算平台上，并行程序可取得的最大加速比是多少？\", \"3\": \"M/(0.85085+0.015M)\", \"0\": \"M/0.85\", \"2\": \"M/(0.85085+0.165M)\"}','C','',3),(116,0,'{\"title\": \"缓存一致性强迫多个线程看起来好像是共享同一个内存单元，这称为()\", \"len\": 2, \"1\": \"伪共享\", \"0\": \"共享\"}','B','',3),(117,0,'{\"len\": 4, \"1\": \"堆\", \"title\": \"在 OpenMP 中，用 threadprivate 作用域标记的变量会存储在内存中的什么位置：\", \"3\": \"DATA 段\", \"0\": \"栈\", \"2\": \"线程局部存储\"}','C','',3),(118,0,'{\"title\": \"Intel(R)线程档案器为 OpenMP  提供了哪些功能？( ) A  并行代码和顺序代码的时间花费\", \"len\": 3, \"1\": \"并行过载和顺序过载\", \"0\": \"线程任务量不均衡\", \"2\": \"以上都是\"}','C','',3),(119,0,'{\"title\": \"MPI 的名字( )  前缀 MPI_\", \"len\": 3, \"1\": \"都有\", \"0\": \"都没有\", \"2\": \"可有可无\"}','B','',3),(120,0,'{\"title\": \"在 MPI 里涉及通信子中所有进程的通信函数是函数 ( )\", \"len\": 3, \"1\": \"集合通信\", \"0\": \"点对点通信\", \"2\": \"广播\"}','B','',3),(121,0,'{\"len\": 4, \"1\": \"任务串行\", \"title\": \"编写并行程序将待解决问题所需要处理的数据分配给各个核的方法是（）\", \"3\": \"数据串行\", \"0\": \"任务并行\", \"2\": \"数据并行\"}','C','',3),(122,0,'{\"len\": 4, \"1\": \"16\", \"title\": \"AMD 的 Radeon7970 图形卡包括（ ）个向量处理器(计算单元)?\", \"3\": \"64\", \"0\": \"4\", \"2\": \"32\"}','C','',3),(123,0,'{\"len\": 4, \"1\": \"静态功率\", \"title\": \"CMOS 的动态功耗等于\", \"3\": \"动态功率与静态功率之和\", \"0\": \"动态功率\", \"2\": \"动态功率和静态功率中较小的功率\"}','D','',3),(124,0,'{\"title\": \"串行时间与并行时间的比值叫做\", \"len\": 2, \"1\": \"加速比\", \"0\": \"效率\"}','B','',3),(125,0,'{\"len\": 4, \"1\": \"142\", \"title\": \"要配置双精度浮点峰值性能是 20TFlops 的 HPC 集群，目前采用双路 2.93GHz  Intel  westmere 六核处理器 X5670来构建，我们知道该处理器的每个核都有两套浮点向量计算单元，问该集群共需要多少个计算节点？\", \"3\": \"36；\", \"0\": \"284\", \"2\": \"71\"}','B','',3),(126,0,'{\"len\": 4, \"1\": \"KNC\", \"title\": \"What\'s the code name of 2nd generation Xeon Phi product?\", \"3\": \"KNH\", \"0\": \"KNF\", \"2\": \"KNL\"}','C','',3),(127,0,'{\"len\": 4, \"1\": \"48\", \"title\": \"How many cores on the Intel Xeon Phi product at least?\", \"3\": \"72\", \"0\": \"61\", \"2\": \"57\"}','C','',3),(128,0,'{\"len\": 4, \"1\": \"2\", \"title\": \"How many VPU will be available on the 2nd generation Xeon Phi product?\", \"3\": \"4\", \"0\": \"1\", \"2\": \"3\"}','B','',3),(129,0,'{\"title\": \"Which one is not the frequently used skills to tune MPI application?\", \"len\": 3, \"1\": \"Remove MPI barrier\", \"0\": \"Relace static task partition with dynamic task partition\", \"2\": \"atomic computation\"}','C','',3),(130,0,'{\"len\": 4, \"1\": \"Replace 2D structure with 1D\", \"title\": \"Which skill is not used for data restructure?\", \"3\": \"Loop fusion and Loop Split\", \"0\": \"Replace arrays with temporary variable\", \"2\": \"AoS-＞SoA\"}','D','',3),(131,1,'{\"title\": \"下面是 MPI 可以绑定的语言的是( )\", \"len\": 3, \"1\": \"C++语言\", \"0\": \"C 语言\", \"2\": \"Fortran  语言\"}','A;B;C','',3),(132,1,'{\"title\": \"MPI 的消息传递过程分为 ( )\", \"len\": 3, \"1\": \"消息装配\", \"0\": \"消息拆卸\", \"2\": \"消息传递\"}','A;B;C','',3),(133,1,'{\"len\": 4, \"1\": \"合并\", \"title\": \"如果进程是执行的“主线程”，其他线程由主线程启动和停止，那么我们可以设想进程和它的子线程如下进行， 当一个线程开始时，它从进程中（ ）出来；当一个线程结束，它（ ）到进程中。\", \"3\": \"消亡\", \"0\": \"派生\", \"2\": \"分离\"}','A;B','',3),(134,1,'{\"len\": 6, \"1\": \"执行终止\", \"title\": \"作为多遍优化算法 PGO 的三步过程由以下哪三步构成？( )\", \"5\": \"代码执行与评估\", \"3\": \"执行被插入信息采集代码的程序(Instrumented execution)\", \"4\": \"插入信息采集代码后编译(Instrumented compilation)\", \"0\": \"代码编译\", \"2\": \"反馈编译（feedback compilation）\"}','C;D','',3),(135,1,'{\"len\": 4, \"1\": \"使用原子操作来替代锁。\", \"title\": \"对于如何解决串行化方面的难题，以下表述正确的是：()\", \"3\": \"设计并行指令\", \"0\": \"少用锁，甚至采用无锁编程。\", \"2\": \"从设计和算法层面来缩小串行化所占的比例。\"}','A;B;C','',3),(136,1,'{\"len\": 4, \"1\": \"在 MPI 并行程序中，同一个串行函数，可以同时被多个进程分别执行\", \"title\": \"关于函数调用，下列哪些说法是正确的？\", \"3\": \"在 pthread 并行程序中，不允许 worker 线程执行线程创建操作\", \"0\": \"在 pthread 并行程序中，不允许 worker 线程执行函数调用\", \"2\": \"在 MPI 并行程序中，如果一个某个函数的数据运算划分到多个处理器上并行执行，则在参与计算的处理器 上都要执行该函数的调用\"}','B;C;D','',3),(137,1,'{\"title\": \"The common used vectorization methods include__\", \"len\": 2, \"1\": \"Intrinsics\", \"0\": \"Auto-Vectorized using \\\"pragma\\\" *B Intel? Cilk? Plus Array Notations *C Elemental Functions\"}','A;B','',3),(138,1,'{\"title\": \"To achieve the good load balance, which items may be needs to considered?\", \"len\": 3, \"1\": \"Communication and I/O\", \"0\": \"Computation Granularity *B Load Balance\", \"2\": \"Synchronization Overhead\"}','A;B;C','',3),(139,1,'{\"len\": 4, \"1\": \"pragma simd\", \"title\": \"Frenquently used pragma for vectorization includes\", \"3\": \"pragma loop count(n)\", \"0\": \"pragma ivdep\", \"2\": \"pragma vector align\"}','A;B;C;D','',3),(140,0,'{\"len\": 4, \"1\": \"堆\", \"title\": \"在 OpenMP 中，用 threadprivate 作用域标记的变量会存储在内存中的什么位置：\", \"3\": \"DATA 段\", \"0\": \"栈\", \"2\": \"线程局部存储\"}','C','',3),(141,0,'{\"len\": 4, \"1\": \"网格\", \"title\": \"（）提供一种基础架构，使地理上分布的计算机大型网络转换成一个分布式内存系统，通常这样的系统是异构 的。\", \"3\": \"共享内存系统\", \"0\": \"集群\", \"2\": \"分布式内存系统\"}','B','',3),(142,0,'{\"title\": \"在 MPI 里涉及通信子中所有进程的通信函数是函数 ( )\", \"len\": 3, \"1\": \"集合通信\", \"0\": \"点对点通信\", \"2\": \"广播\"}','B','',3),(143,0,'{\"len\": 4, \"1\": \"在引入线程的操作系统中，则把线程作为 CPU  调度和分派的基本单位\", \"title\": \"以下表述不正确的是：( )\", \"3\": \"由一个进程中的线程切换到另一进程中的线程时，也不会引起进程切换\", \"0\": \"在传统的操作系统中，CPU  调度和分派的基本单位是进程\", \"2\": \"同一进程中线程的切换不会引起进程切换，从而避免了昂贵的系统调用\"}','D','',3),(144,0,'{\"title\": \"一个条件变量总是与一个 ( )相关联\", \"len\": 2, \"1\": \"互斥量\", \"0\": \"信号量\"}','B','',3),(145,0,'{\"len\": 4, \"1\": \"任务,线程\", \"title\": \"OpenCL 提供了基于()和基于()的两种并行计算方式.\", \"3\": \"进程,数据\", \"0\": \"任务,数据\", \"2\": \"数据,线程\"}','A','',3),(146,0,'{\"title\": \"当 CPU 向 Cache 中写数据时，Cache 中的值就会不同或者不一致，有两种方法：写直达和（ ）来解决这个不一 致性问题。\", \"len\": 3, \"1\": \"重复写\", \"0\": \"写回法\", \"2\": \"备份\"}','A','',3),(147,0,'{\"len\": 4, \"1\": \"并行程序的运行时间越短，加速比越高\", \"title\": \"关于加速比，正确的说法是：\", \"3\": \"根据 Amdahl 定理，并行程序的加速比小于参与计算的处理器执行核数量\", \"0\": \"在 MIM*D 并行计算机上，并行程序的加速比不能随处理器执行核的数量按比例增长\", \"2\": \"确定了运行计算平台、及所使用的处理器数量，就可以确定并行程序的加速比\"}','A','',3),(148,0,'{\"len\": 4, \"1\": \"负载平衡\", \"title\": \"在（）中，一个进程必须调用一个发送函数，并且发送函数必须与另一个进程调用的接受函数相匹配。\", \"3\": \"异步\", \"0\": \"消息传递\", \"2\": \"同步\"}','A','',3),(149,0,'{\"len\": 4, \"1\": \"任务串行\", \"title\": \"编写并行程序将待解决问题所需要处理的数据分配给各个核的方法是（）\", \"3\": \"数据串行\", \"0\": \"任务并行\", \"2\": \"数据并行\"}','C','',3),(150,0,'{\"title\": \"#pragma omp for collapse(2)的作用是什么？\", \"len\": 3, \"1\": \"最里层 for 循环用两个线程处理\", \"0\": \"合并最里面两层循环\", \"2\": \"合并最外两层循环\"}','C','',3),(151,0,'{\"title\": \"（ ）是指计时器的时间测量单位，是计时器在计时的过程中最短的非零时间跨度。\", \"len\": 3, \"1\": \"电压\", \"0\": \"分辨率\", \"2\": \"电流\"}','A','',3),(152,0,'{\"title\": \"条件变量是一个数据对象，允许线程在某个特定条件或事件发生前都处于 ( )状态\", \"len\": 2, \"1\": \"挂起\", \"0\": \"死锁\"}','B','',3),(153,0,'{\"len\": 4, \"1\": \"并行计算机访存模型只有 NUMA、COMA 和 NORMA 这三种类型\", \"title\": \"下面哪个关于并行计算机的访存模型描述是对的？\", \"3\": \"COMA 模型是 Coherent-Only Memory Access 的缩写。\", \"0\": \"NUMA 模型是高速缓存一致的、非均匀存储访问模型的简称。\", \"2\": \"多台 P*C 机通过网线连接形成的机群属于 NORM*A 非远程存储访问模型。\"}','C','',3),(154,0,'{\"title\": \"在一个集合通信中，如果属于一个进程的数据被发送到通信子中的所有进程，则这样的集合通信叫做 ( ) A  点对点通信\", \"len\": 2, \"1\": \"广播\", \"0\": \"集合通信\"}','B','',3),(155,0,'{\"title\": \"串行时间与并行时间的比值叫做\", \"len\": 2, \"1\": \"加速比\", \"0\": \"效率\"}','B','',3),(156,0,'{\"title\": \"不同进程对同一个内容的输出，其顺序是( )\", \"len\": 2, \"1\": \"特定的\", \"0\": \"随机的\"}','A','',3),(157,0,'{\"len\": 4, \"1\": \"共享存储并行计算模型包括 LogP 模型和 PRAM 模型\", \"title\": \"下面关于并行计算模型，哪个描述是正确的？\", \"3\": \"分布式存储并行计算模型包括 LogP 模型和 BSP 模型；\", \"0\": \"共享存储并行计算模型包括 PRAM 模型和 BSP 模型\", \"2\": \"分布式存储并行计算模型包括 PRAM 模型和 BSP 模型\"}','D','',3),(158,0,'{\"len\": 4, \"1\": \"CUDA\", \"title\": \"（ ）和 OpenMP 是为共享内存系统的编程而设计的，它们提供访问共享内存的机制。\", \"3\": \"Pthreads\", \"0\": \"MPI\", \"2\": \"MapReduce\"}','D','',3),(159,0,'{\"len\": 4, \"1\": \"2X\", \"title\": \"How much improvement of Single-Thread Performance on 2nd generation compared to the 1st generation Intel Xeon Phi coprocessor?\", \"3\": \"4X\", \"0\": \"3X\", \"2\": \"1.5X\"}','A','',3),(160,0,'{\"len\": 4, \"1\": \"512bits\", \"title\": \"How long is vector length on Xeon Phi?\", \"3\": \"64bits\", \"0\": \"128bits\", \"2\": \"256bits\"}','B','',3),(161,0,'{\"len\": 4, \"1\": \"8GB\", \"title\": \"What \'s the maxmum size of on-package memory (MCDRAM) will be available on 2nd generation Xeon Phi?\", \"3\": \"32GB\", \"0\": \"4GB\", \"2\": \"16GB\"}','C','',3),(162,0,'{\"len\": 4, \"1\": \"4\", \"title\": \"How many channels of DDR4 will be available on 2nd generation Xeon Phi?\", \"3\": \"10\", \"0\": \"6\", \"2\": \"8\"}','A','',3),(163,0,'{\"len\": 4, \"1\": \"KNC\", \"title\": \"What\'s the code name of 2nd generation Xeon Phi product?\", \"3\": \"KNH\", \"0\": \"KNF\", \"2\": \"KNL\"}','C','',3),(164,1,'{\"title\": \"下面是 MPI 可以绑定的语言的是( )\", \"len\": 3, \"1\": \"C++语言\", \"0\": \"C 语言\", \"2\": \"Fortran  语言\"}','A;B;C','',3),(165,1,'{\"len\": 4, \"1\": \"MKL  使用 OpenMP*  实现多线程\", \"title\": \"下面关于英特 MKL 多线程的特性，哪些是正确的？( )\", \"3\": \"MKL  函数内部实现了多线程，但 MKL 库不是线程安全的\", \"0\": \"MKL  是线程安全的， 可以在多线程中被使用\", \"2\": \"MKL  函数内部实现了多线程\"}','A;B;C','',3),(166,1,'{\"title\": \"TBB 支持的 C++编译器包括：( )\", \"len\": 3, \"1\": \"GNU\", \"0\": \"Microsoft\", \"2\": \"Intel\"}','A;B;C','',3),(167,1,'{\"title\": \"以下属于 TBB 中的并行容器的是：( )\", \"len\": 3, \"1\": \"concurrent_queue\", \"0\": \"concurrent_set\", \"2\": \"concurrent_hash_map *D concurrent_vector\"}','B;C','',3),(168,1,'{\"len\": 5, \"1\": \"执行终止\", \"title\": \"作为多遍优化算法 PGO 的三步过程由以下哪三步构成？( )\", \"3\": \"执行被插入信息采集代码的程序(Instrumented execution) E  插入信息采集代码后编译(Instrumented compilation)\", \"4\": \"代码执行与评估\", \"0\": \"代码编译\", \"2\": \"反馈编译（feedback compilation）\"}','C;D','',3),(169,1,'{\"len\": 4, \"1\": \"进程 0 先执行 MPI_Recv 接收 M1、然后执行 MPI_Send 发送 M0，进程 1 执行 MPI_Recv 接收 M0、然后先执行 MPI_Send 发送 M1\", \"title\": \"进程 0 要将消息 M0 发送给进程 1，进程 1 要将消息 M1 发送给进程 0。下列哪几种情况下，可能出现“死锁”？\", \"3\": \"进程 0 先执行 MPI_IRecv 接收 M1、然后执行 MPI_Send 发送 M0，进程 1 执行 MPI_Recv 接收 M0、然后先执行 MPI_Send 发送 M1\", \"0\": \"进程 0 先执行 MPI_Send 发送 M0、然后执行 MPI_Recv 接收 M1，进程 1 先执行 MPI_Send 发送 M1、然后执行 MPI_Recv 接收 M0\", \"2\": \"进程 0 先执行 MPI_ISend 发送 M0、然后执行 MPI_Recv 接收 M1，进程 1 先执行 MPI_Send 发送 M1、然后执行 MPI_Recv 接收 M0\"}','A;B;C','',3),(170,1,'{\"title\": \"MPI 的消息传递过程分为 ( )\", \"len\": 3, \"1\": \"消息装配\", \"0\": \"消息拆卸\", \"2\": \"消息传递\"}','A;B;C','',3),(171,1,'{\"len\": 4, \"1\": \"处理器的乱序执行\", \"title\": \"以下哪些选项有可能使得程序不会按照程序本身的顺序执行的\", \"3\": \"使用单核 CPU\", \"0\": \"编译器的编译优化\", \"2\": \"使用原子操作\"}','A;B','',3),(172,1,'{\"len\": 4, \"1\": \"pragma prefetch\", \"title\": \"In order to improve memory bandwidth, comman used skills inlclude:\", \"3\": \"AoS-＞SoA\", \"0\": \"Use nontemporal pragma\", \"2\": \"the option of \\\"-qopt-streaming-stores=always\\\"\"}','A;C','',3),(173,1,'{\"title\": \"Data alignment about dynamic memory can be achieved by __.\", \"len\": 3, \"1\": \"mm_aligned_malloc(size, alignment_bytes)/);    mm_aligned_free()\", \"0\": \"__attribute    ((aligned(n)))\", \"2\": \"scalable_aligned_malloc()/scalable_aligned_free()\"}','B;C','',3),(174,0,'{\"len\": 4, \"1\": \"70%\", \"title\": \"某并行任务中，通信部分占总时间 50%，计算占%40，而并行带来的额外开销占%10。经过优化，使得 通信与计算得到部分重叠，有 40%的通信时间被计算重叠。此时，总时间为原本的\", \"3\": \"90%\", \"0\": \"60%\", \"2\": \"80%\"}','C','',3),(175,0,'{\"title\": \"（ ）为程序员提供了一种机制，将程序划分为多个大致独立的任务，当某个任务阻塞时能执行其他任 务。\", \"len\": 3, \"1\": \"线程\", \"0\": \"进程\", \"2\": \"接口\"}','B','',3),(176,0,'{\"len\": 4, \"1\": \"1\", \"title\": \"在 Concurrent read concurrent write (CRCW) PRAM 模型中，两个处理器同时对初值为 0 的内存空间进行 加一操作（*p = *p + 1）。当其中一个处理器完成其操作时，该内存空间不可能的值是：\", \"3\": \"以上都有可能\", \"0\": \"0\", \"2\": \"2\"}','A','',3),(177,0,'{\"len\": 4, \"1\": \"Store-conditional 指令和普通的 Store 指令没有差别，只是多核处理器上的特别叫法。\", \"title\": \"下面关于 Load-link 和 Store-conditional 指令的说法，正确的是\", \"3\": \"Load-link 指令有可能失败。\", \"0\": \"Load-link 和普通的 Load 指令没有差别，只是多核处理器上的特别叫法。\", \"2\": \"Load-link 和 Store-conditional 指令可以用于实现同步原语。\"}','C','',3),(178,0,'{\"len\": 4, \"1\": \"并行计算机访存模型只有 NUMA、COMA 和 NORMA 这三种类型\", \"title\": \"下面哪个关于并行计算机的访存模型描述是对的？\", \"3\": \"COMA 模型是 Coherent-Only Memory Access 的缩写。\", \"0\": \"NUMA 模型是高速缓存一致的、非均匀存储访问模型的简称。\", \"2\": \"多台 PC 机通过网线连接形成的机群属于 NORMA 非远程存储访问模型。\"}','C','',3),(179,0,'{\"len\": 4, \"1\": \"速率\", \"title\": \"链路的（ ）是指它传输数据的速度。\", \"3\": \"延迟带宽积\", \"0\": \"带宽\", \"2\": \"延迟\"}','A','',3),(180,0,'{\"len\": 4, \"1\": \"barrier\", \"title\": \"在并行域当中，指定一个数据操作原子性操作完成，是使用什么关键字\", \"3\": \"master\", \"0\": \"atomic\", \"2\": \"single\"}','A','',3),(181,0,'{\"len\": 4, \"1\": \"测试阶段\", \"title\": \"我们应该在产品生命周期中的哪个阶段考虑产品的性能？( )?\", \"3\": \"以上全部?\", \"0\": \"设计阶段\", \"2\": \"需求收集阶段\"}','C','',3),(182,0,'{\"len\": 4, \"1\": \"1\", \"title\": \"在 Exclusive read exclusive write (EREW) PRAM 模型中，三个处理器同时对初值为 0 的内存空间进行加一 操作（*p = *p + 1）。当所有处理器完成其操作时，该内存空间不可能的值是：\", \"3\": \"以上均不可能\", \"0\": \"0\", \"2\": \"2\"}','D','',3),(183,0,'{\"len\": 4, \"1\": \"线程\", \"title\": \"有两种主要方法来实现指令级并行：流水线和（ ）。\", \"3\": \"多发射\", \"0\": \"进程\", \"2\": \"接口\"}','D','',3),(184,0,'{\"len\": 4, \"1\": \"2\", \"title\": \"Intel Xeon Phi 处理器中，每个核有几个硬件线程。\", \"3\": \"8\", \"0\": \"1\", \"2\": \"4\"}','C','',3),(185,0,'{\"len\": 4, \"1\": \"single\", \"title\": \"在并行域当中，使代码线程同步，是使用什么关键字\", \"3\": \"master\", \"0\": \"barrier\", \"2\": \"atomic\"}','A','',3),(186,0,'{\"len\": 4, \"1\": \"运行\", \"title\": \"在（ ）时，一个线程进入一个循环，这个循环的目的只是测试一个条件。\", \"3\": \"休眠\", \"0\": \"忙等待\", \"2\": \"就绪\"}','A','',3),(187,0,'{\"len\": 4, \"1\": \"512bits\", \"title\": \"How long is vector length on Xeon Phi?\", \"3\": \"64bits\", \"0\": \"128bits\", \"2\": \"256bits\"}','B','',3),(188,0,'{\"len\": 4, \"1\": \"2\", \"title\": \"How many VPU will be available on the 2nd generation Xeon Phi product?\", \"3\": \"4\", \"0\": \"1\", \"2\": \"3\"}','B','',3),(189,0,'{\"len\": 4, \"1\": \"2X\", \"title\": \"How much improvement of Single-Thread Performance on 2nd generation compared to the 1st generation Intel Xeon Phi coprocessor?\", \"3\": \"4X\", \"0\": \"3X\", \"2\": \"1.5X\"}','A','',3),(190,0,'{\"title\": \"How many cores on the Intel Xeon Phi product at least?\", \"len\": 3, \"1\": \"48\", \"0\": \"61\", \"2\": \"57\"}','C','',3),(191,0,'{\"len\": 4, \"1\": \"Cache blocking\", \"title\": \"Which one is the freqently used skill to improve data locality?\", \"3\": \"data restructure\", \"0\": \"Data alignment\", \"2\": \"Prefetch\"}','B','',3),(192,0,'{\"len\": 4, \"1\": \"O2\", \"title\": \"What\'s the default vectorization option for Intel Compiler?\", \"3\": \"O0\", \"0\": \"O1\", \"2\": \"O3\"}','B','',3),(193,0,'{\"len\": 4, \"1\": \"8GB\", \"title\": \"What \'s the maxmum size of on-package memory (MCDRAM) will be available on 2nd generation Xeon Phi?\", \"3\": \"32GB\", \"0\": \"4GB\", \"2\": \"16GB\"}','C','',3),(194,1,'{\"len\": 4, \"1\": \"使用原子操作来替代锁。\", \"title\": \"对于如何解决串行化方面的难题，以下表述正确的是：()\", \"3\": \"设计并行指令\", \"0\": \"少用锁，甚至采用无锁编程。\", \"2\": \"从设计和算法层面来缩小串行化所占的比例。\"}','A;B;C','',3),(195,1,'{\"len\": 4, \"1\": \"在引入线程的操作系统中，一个进程中的多个线程之间不可以并发执行\", \"title\": \"以下表述正确的是：( )\", \"3\": \"线程是拥有系统资源的一个独立单位，它可以拥有自己的资源\", \"0\": \"在引入线程的操作系统中，进程之间可以并发执行\", \"2\": \"进程是拥有系统资源的一个独立单位，它可以拥有自己的资源\"}','A;C','',3),(196,1,'{\"title\": \"Intel  调优助手能够给我们自动推荐代码改进办法，主要有以下哪些方面？ ( ) A  算法自动改进\", \"len\": 3, \"1\": \"取样向导增强\", \"0\": \"处理器瓶颈以及改进\", \"2\": \"超线程\"}','A;B;C','',3),(197,1,'{\"title\": \"避免对临界区竞争访问的基本方法有 ()\", \"len\": 3, \"1\": \"互斥量\", \"0\": \"忙等待\", \"2\": \"信号量\"}','A;B;C','',3),(198,1,'{\"title\": \"请说出目前 MPI 的主要免费实现的种类 ()\", \"len\": 3, \"1\": \"LAM\", \"0\": \"MPICH\", \"2\": \"CHIMP\"}','A;B;C','',3),(199,1,'{\"title\": \"TBB 支持的 C++编译器包括：( )\", \"len\": 3, \"1\": \"GNU\", \"0\": \"Microsoft\", \"2\": \"Intel\"}','A;B;C','',3),(200,1,'{\"len\": 4, \"1\": \"Offload\", \"title\": \"The features supported on the 1st generation Xeon Phi include__\", \"3\": \"Symmetric\", \"0\": \"Native\", \"2\": \"Self-boot\"}','A;B;D','',3),(201,1,'{\"len\": 4, \"1\": \"pragma prefetch\", \"title\": \"In order to improve memory bandwidth, comman used skills inlclude:\", \"3\": \"AoS-＞SoA\", \"0\": \"Use nontemporal pragma\", \"2\": \"the option of \\\"-qopt-streaming-stores=always\\\"\"}','A;C','',3),(202,0,'{\"title\": \"以下哪个事例是 Vtune 性能分析器的基于事件的采样？ ( )\", \"len\": 3, \"1\": \"Every n processor ticks\", \"0\": \"Branch misprediction\", \"2\": \"Bugs encountered\"}','A','',3),(203,0,'{\"len\": 4, \"1\": \"1MB\", \"title\": \"Mmap()函数可以申请大页表空间，请问它申请的空间，每个页表的大小是多少?\", \"3\": \"4MB\", \"0\": \"512KB\", \"2\": \"2MB\"}','C','',3),(204,0,'{\"len\": 4, \"1\": \"data section\", \"title\": \"同一进程下的线程可以共享以下\", \"3\": \"thread ID\", \"0\": \"stack\", \"2\": \"register set\"}','B','',3),(205,0,'{\"title\": \"在 MPI 中 ( )  指的是一组可以互相发送消息的进程集合\", \"len\": 2, \"1\": \"标签\", \"0\": \"通信子\"}','A','',3),(206,0,'{\"title\": \"如果程序可以在不增加问题规模的前提下维持恒定效率，那么程序拥有( )  扩展性\", \"len\": 2, \"1\": \"强\", \"0\": \"弱\"}','B','',3),(207,0,'{\"title\": \"在任何一个 MIMD 系统中，如果处理器异步执行，那么很可能会引发（ ）。\", \"len\": 3, \"1\": \"弱确定性\", \"0\": \"强确定性\", \"2\": \"非确定性\"}','C','',3),(208,0,'{\"title\": \"如果一个进程试图接收消息，但没有相匹配的消息，那么该进程将会被永远阻塞在那里,这种情况叫做( )\", \"len\": 3, \"1\": \"进程阻\", \"0\": \"进程悬挂\", \"2\": \"进程死锁\"}','A','',3),(209,0,'{\"title\": \"在 Pthreads 中实现路障的更好方法是采用 ( )\", \"len\": 2, \"1\": \"互斥量\", \"0\": \"条件变量\"}','A','',3),(210,0,'{\"len\": 4, \"1\": \"一个条件信号可以唤醒多个线程\", \"title\": \"关于 pthread 线程并行模型，正确的说法是：\", \"3\": \"采用互斥锁机制，可以解决线程之间的“读-写”冲突\", \"0\": \"各个线程共享同一个存储空间\", \"2\": \"允许两个线程同时处于相同的临界区\"}','B','',3),(211,0,'{\"len\": 4, \"1\": \"在创建或撤消进程时，系统都要为之分配或回收资源\", \"title\": \"以下表述不正确的是：( )\", \"3\": \"线程切换只需保存和设置少量寄存器的内容，并不涉及存储器管理方面的操作\", \"0\": \"人们习惯上称线程为轻量级进程（lightweight process, LWP），线程是 CPU  调度和分派的基本单元\", \"2\": \"进程切换的开销也远小于线程切换的开销\"}','C','',3),(212,0,'{\"len\": 4, \"1\": \"采用超标量技术\", \"title\": \"提高微处理器内部执行的并行性有哪些措施。( )\", \"3\": \"以上都不是\", \"0\": \"采用超级流水线技术\", \"2\": \"以上都是\"}','C','',3),(213,0,'{\"len\": 4, \"1\": \"重复写\", \"title\": \"在（ ）Cache 中，当 CPU 向 Cache 写数据时，高速缓存行会立即写入主存中。\", \"3\": \"写直达\", \"0\": \"写回法\", \"2\": \"备份\"}','D','',3),(214,0,'{\"title\": \"通常（ ）用对并行硬件进行分类，通过系统可以处理的指令流数目和数据流数目来区别各个分类。\", \"len\": 3, \"1\": \"PCAM 方法\", \"0\": \"Flynn 分类法\", \"2\": \"KMP 算法\"}','A','',3),(215,0,'{\"len\": 4, \"1\": \"测试阶段\", \"title\": \"我们应该在产品生命周期中的哪个阶段考虑产品的性能？( )?\", \"3\": \"以上全部?\", \"0\": \"设计阶段\", \"2\": \"需求收集阶段\"}','C','',3),(216,0,'{\"title\": \"当用户运行一个程序时，操作系统创建一个（ ）。\", \"len\": 3, \"1\": \"线程\", \"0\": \"进程\", \"2\": \"接口\"}','A','',3),(217,0,'{\"len\": 4, \"1\": \"线程是 CPU 调度和分派的基本单位\", \"title\": \"关于进程和线程的描述中不正确的是\", \"3\": \"线程必须依存在进程中，由进程提供多个线程执行的控制\", \"0\": \"进程和线程都可以独立执行\", \"2\": \"进程是系统进行资源分配和调度的一个独立单位\"}','A','',3),(218,0,'{\"len\": 4, \"1\": \"MPI_Allreduce\", \"title\": \"在 MPI 集合通信中，下列哪一个函数可以完成多个进程间的前缀和（prefix sum）计算：\", \"3\": \"MPI_Scan\", \"0\": \"MPI_Reduce\", \"2\": \"MPI_Reduce_scatter\"}','D','',3),(219,0,'{\"title\": \"MPI 要求消息是 ( )\", \"len\": 2, \"1\": \"可超越的\", \"0\": \"不可超越的\"}','A','',3),(220,0,'{\"len\": 4, \"1\": \"请求与保持条件：一个进程因请求资源而阻塞时，对已获得的资源保持不放\", \"title\": \"产生死锁的必要条件不包括\", \"3\": \"循环等待条件:若干进程之间形成一种头尾相接的循环等待资源关系\", \"0\": \"互斥条件：一个资源每次只能被一个进程使用\", \"2\": \"资源分配不当:资源分配的顺序不合理\"}','C','',3),(221,0,'{\"title\": \"标签不匹配和目标进程的进程号与源进程的进程号不相同都会导致 （）\", \"len\": 3, \"1\": \"进程阻碍\", \"0\": \"进程悬挂\", \"2\": \"进程死锁\"}','A','',3),(222,0,'{\"len\": 4, \"1\": \"IMCI\", \"title\": \"What\'s the instruction set on 2nd generation xeon phi?\", \"3\": \"AVX-512\", \"0\": \"SSE\", \"2\": \"AVX2\"}','D','',3),(223,0,'{\"len\": 4, \"1\": \"pragma prefetch\", \"title\": \"Which skill is not used for prefetch?\", \"3\": \"Cache blocking\", \"0\": \"Add compiler option\", \"2\": \"prefetch intrinsic\"}','D','',3),(224,1,'{\"title\": \"请说出目前 MPI 的主要免费实现的种类 ()\", \"len\": 3, \"1\": \"LAM\", \"0\": \"MPICH\", \"2\": \"CHIMP\"}','A;B;C','',3),(225,1,'{\"len\": 4, \"1\": \"避免冗余的函数调用\", \"title\": \"独立于体系结构性能优化方法主要有：( )\", \"3\": \"利 用局部变量保存中间计算结果\", \"0\": \"编写适用于特定 CPU  的优化代码\", \"2\": \"避免不必要的边界检查\"}','B;C;D','',3),(226,1,'{\"len\": 4, \"1\": \"合并\", \"title\": \"如果进程是执行的“主线程”，其他线程由主线程启动和停止，那么我们可以设想进程和它的子线程如 下进行，当一个线程开始时，它从进程中（ ）出来；当一个线程结束，它（ ）到进程中。\", \"3\": \"消亡\", \"0\": \"派生\", \"2\": \"分离\"}','A;B','',3),(227,1,'{\"len\": 4, \"1\": \"扩展指令集\", \"title\": \"对于现代微处理器体系结构而言，对性能优化影响比较大的主要是：( )\", \"3\": \"指令流水线的深度\", \"0\": \"超标量\", \"2\": \"乱序执行\"}','A;C;D','',3),(228,1,'{\"len\": 4, \"1\": \"IPP 性能库\", \"title\": \"英特尔 Parallel Composer 主要包含：( )\", \"3\": \"TBB 多线程开发库\", \"0\": \"Intel C/C++编译器\", \"2\": \"MKL 函数库\"}','A;B;D','',3),(229,1,'{\"len\": 4, \"1\": \"随机取样\", \"title\": \"VTune  性能分析器中的取样功能有哪几种方式？()\", \"3\": \"线性取样\", \"0\": \"基于时间取样\", \"2\": \"基于事件取样\"}','A;C','',3),(230,1,'{\"len\": 4, \"1\": \"进程 0 先执行 MPI_Recv 接收 M1、然后执行 MPI_Send 发送 M0，进程 1 执行 MPI_Recv 接收 M0、然后先执行 MPI_Send 发送 M1\", \"title\": \"进程 0 要将消息 M0 发送给进程 1，进程 1 要将消息 M1 发送给进程 0。下列哪几种情况下，可能出现 “死锁”？\", \"3\": \"进程 0 先执行 MPI_IRecv 接收 M1、然后执行 MPI_Send 发送 M0，进程 1 执行 MPI_Recv 接收 M0、然后先执行 MPI_Send 发送 M1\", \"0\": \"进程 0 先执行 MPI_Send 发送 M0、然后执行 MPI_Recv 接收 M1，进程 1 先执行 MPI_Send 发送 M1、然后执行 MPI_Recv 接收 M0\", \"2\": \"进程 0 先执行 MPI_ISend 发送 M0、然后执行 MPI_Recv 接收 M1，进程 1 先执行 MPI_Send 发送 M1、然后执行 MPI_Recv 接收 M0\"}','A;B;C','',3),(231,0,'{\"title\": \"Data alignment about dynamic memory can be achieved by_    .\", \"len\": 2, \"1\": \"mm_aligned_malloc(size, alignment_bytes)/);    mm_aligned_free() *C scalable_aligned_malloc()/scalable_aligned_free()\", \"0\": \"__attribute    ((aligned(n)))\"}','B','',3),(232,1,'{\"title\": \"Which are the frenquently used multi-thread parallelization methods? A MPI\", \"len\": 3, \"1\": \"Intel Cilk Plus,\", \"0\": \"OpenMP\", \"2\": \"Intel Threading Building Blocks\"}','A;B;C','',3),(233,0,'{\"title\": \"使用 Intel 编译器时，开关-O2 对代码进行和开关-O1 或/O1 相类似的优化，但是会以什么为“代价”？( )\", \"2\": \"性能优势将只能发挥在某些特定硬件平台上\", \"len\": 3, \"0\": \"没有区别所以没有代价\", \"1\": \"和-O1(/O1)相比可能会大幅增加代码大小\"}','C','',3),(234,0,'{\"len\": 4, \"1\": \"测试阶段\", \"title\": \"我们应该在产品生命周期中的哪个阶段考虑产品的性能？( )\", \"3\": \"以上全部?\", \"0\": \"设计阶段\", \"2\": \"需求收集阶段\"}','C','',3),(235,0,'{\"len\": 4, \"1\": \"寄存器集合\", \"title\": \"一个标准的线程不一定需要哪一项资源？\", \"3\": \"堆\", \"0\": \"程序计数器\", \"2\": \"堆栈\"}','D','',3),(236,0,'{\"len\": 4, \"1\": \"critical\", \"title\": \"在并行域当中，保证各个 openmp 线程数据影像的一致性，是使用什么关键字\", \"3\": \"master\", \"0\": \"flush\", \"2\": \"atomic\"}','A','',3),(237,0,'{\"len\": 4, \"1\": \"速率\", \"title\": \"两个常用来衡量互连网络性能的指标：（ ）和带宽。\", \"3\": \"抖动\", \"0\": \"稳定\", \"2\": \"延迟\"}','C','',3),(238,0,'{\"len\": 4, \"1\": \"使用线程池可以避免为每个线程创建新进程的开销\", \"title\": \"以下表述错误的是：()\", \"3\": \"对于有优先级的线程，也可以使用线程池\", \"0\": \"OpenMP  可以根据目标系统尽量使用最优数量的线程个数。\", \"2\": \"线程池通常具有最大线程数限制，如果所有线程都繁忙，而额外的任务将放入队列中，直到有线程可用时 才能够得到处理\"}','D','',3),(239,0,'{\"len\": 4, \"1\": \"多指令多数据\", \"title\": \"（ ）系统支持同时多个指令流在多个数据流上操作。\", \"3\": \"共享内存\", \"0\": \"单指令多数据\", \"2\": \"分布式内存\"}','B','',3),(240,0,'{\"title\": \"在任何一个 MIMD 系统中，如果处理器异步执行，那么很可能会引发（ ）。\", \"len\": 3, \"1\": \"弱确定性\", \"0\": \"强确定性\", \"2\": \"非确定性\"}','C','',3),(241,0,'{\"len\": 4, \"1\": \"线程级\", \"title\": \"（ ）并行是尝试通过同时执行不同线程来提供并行性。\", \"3\": \"任务级\", \"0\": \"进程级\", \"2\": \"程序级\"}','B','',3),(242,0,'{\"len\": 4, \"1\": \"可以，不会\", \"title\": \"具有不同局部性的存储单元，__放置在同一 cache 行中，这样__引发伪共享问题。( )\", \"3\": \"不可以，不会\", \"0\": \"可以，会\", \"2\": \"不可以，会\"}','C','',3),(243,0,'{\"len\": 4, \"1\": \"MKL_lapack.lib\", \"title\": \"在 Windows*中静态链接 MKL  的 DFT 函数，应该选择下面哪一个 MKL 库\", \"3\": \"MKL_c_dll.lib\", \"0\": \"MKL_solver.lib\", \"2\": \"MKL_c.lib\"}','B','',3),(244,0,'{\"len\": 4, \"1\": \"寄存器\", \"title\": \"控制单元有一个特殊的存储器，用来存放下一条指令的地址，叫做（ ）\", \"3\": \"程序计数器\", \"0\": \"主存\", \"2\": \"互联结构\"}','D','',3),(245,0,'{\"len\": 4, \"1\": \"16\", \"title\": \"AMD 的 Radeon7970 图形卡包括（ ）个向量处理器(计算单元)?\", \"3\": \"64\", \"0\": \"4\", \"2\": \"32\"}','C','',3),(246,0,'{\"len\": 4, \"1\": \"负载平衡\", \"title\": \"在（）中，一个进程必须调用一个发送函数，并且发送函数必须与另一个进程调用的接受函数相匹配。\", \"3\": \"异步\", \"0\": \"消息传递\", \"2\": \"同步\"}','A','',3),(247,0,'{\"len\": 4, \"1\": \"Data restructure\", \"title\": \"Which optimization methods is not used in the case of \\\"small matrix multiplication\\\"?\", \"3\": \"Cache Blocking\", \"0\": \"Loop Interchange\", \"2\": \"vectorization\"}','D','',3),(248,0,'{\"title\": \"Which optimization may not apply for below code?\", \"len\": 3, \"1\": \"Parallelization and Use \\\"pragma omp atomic\\\" to make sure the right result\", \"0\": \"Vectorize the loop\", \"2\": \"Pre-caculate rand() and store into an array\"}','A','',3),(249,0,'{\"len\": 4, \"1\": \"Improve cache hit rate\", \"title\": \"What is the key reason for performance improvement after replacing Glibc rand() with Intel Math Kernel Library random generator in the case of \\\"Deep Learning\\\"?\", \"3\": \"Parallelization\", \"0\": \"Reduce IO latentcy\", \"2\": \"Vectorization\"}','C','',3),(250,0,'{\"title\": \"Which one is not the potential issue of the code?\", \"len\": 3, \"1\": \"In the most inner loop, bad vectorization effect,even can\'t be vectorized\", \"0\": \"Can\'t be parallelized in the outer loop\", \"2\": \"non-contiguous memory access\"}','A','',3),(251,0,'{\"title\": \"Which option is commanly used for detailed vectorization information? D-no-vec\", \"len\": 3, \"1\": \"-fno-alias\", \"0\": \"-ansi-alias\", \"2\": \"-qopt-report\"}','C','',3),(252,1,'{\"title\": \"MPI 的消息传递过程分为 ( )\", \"len\": 3, \"1\": \"消息装配\", \"0\": \"消息拆卸\", \"2\": \"消息传递\"}','A;B;C','',3),(253,1,'{\"len\": 4, \"1\": \"concurrent_queue\", \"title\": \"以下属于 TBB 中的并行容器的是：( )\", \"3\": \"concurrent_vector\", \"0\": \"concurrent_set\", \"2\": \"concurrent_hash_map\"}','B;C;D','',3),(254,1,'{\"title\": \"避免对临界区竞争访问的基本方法有 ()\", \"len\": 3, \"1\": \"互斥量\", \"0\": \"忙等待\", \"2\": \"信号量\"}','A;B;C','',3),(255,1,'{\"len\": 4, \"1\": \"使用原子操作来替代锁。\", \"title\": \"对于如何解决串行化方面的难题，以下表述正确的是：()\", \"3\": \"设计并行指令\", \"0\": \"少用锁，甚至采用无锁编程。\", \"2\": \"从设计和算法层面来缩小串行化所占的比例。\"}','A;B;C','',3),(256,1,'{\"title\": \"下面是 MPI 可以绑定的语言的是( )\", \"len\": 3, \"1\": \"C++语言\", \"0\": \"C 语言\", \"2\": \"Fortran  语言\"}','A;B;C','',3),(257,1,'{\"len\": 4, \"1\": \"Offload\", \"title\": \"The features supported on the 1st generation Xeon Phi include__\", \"3\": \"Symmetric\", \"0\": \"Native\", \"2\": \"Self-boot\"}','A;B;D','',3),(258,1,'{\"len\": 4, \"1\": \"pragma simd\", \"title\": \"Frenquently used pragma for vectorization includes\", \"3\": \"pragma loop count(n)\", \"0\": \"pragma ivdep\", \"2\": \"pragma vector align\"}','A;B;C;D','',3),(259,1,'{\"len\": 4, \"1\": \"Intel? Cilk? Plus Array Notations\", \"title\": \"The common used vectorization methods include\", \"3\": \"Intrinsics\", \"0\": \"Auto-Vectorized using \\\"pragma\\\"\", \"2\": \"Elemental Functions\"}','A;B;C;D','',3),(260,0,'{\"title\": \"如果当问题规模增加，需要通过增大进程数来维持程序效率的，那么程序拥有（）可扩展性\", \"len\": 2, \"1\": \"强\", \"0\": \"弱\"}','A','',3),(261,0,'{\"title\": \"在并行域当中，指定一段代码由主线程执行，是使用什么关键字\", \"len\": 2, \"1\": \"barrier C atomic D Single\", \"0\": \"master\"}','A','',3),(262,0,'{\"len\": 4, \"1\": \"请求与保持条件：一个进程因请求资源而阻塞时，对已获得的资源保持不放\", \"title\": \"产生死锁的必要条件不包括\", \"3\": \"循环等待条件:若干进程之间形成一种头尾相接的循环等待资源关系\", \"0\": \"互斥条件：一个资源每次只能被一个进程使用\", \"2\": \"资源分配不当:资源分配的顺序不合理\"}','C','',3),(263,0,'{\"title\": \"MPI 要求消息是 ( )\", \"len\": 2, \"1\": \"可超越的\", \"0\": \"不可超越的\"}','A','',3),(264,0,'{\"len\": 4, \"1\": \"每个临界区都有相应的进入区（entry section）和退出区（exit section）\", \"title\": \"以下表述不正确的是：( )\", \"3\": \"临界区的存在就是为了保证当有一个线程在临界区内执行的时候，不能有其他任何进程被允许在临界区执 行\", \"0\": \"当两个或多个进程试图在同一时刻访问共享内存，或读写某些共享数据，就会产生竞争条件\", \"2\": \"可能有两个线程同时进入临界区。\"}','C','',3),(265,0,'{\"title\": \"在共享内存编程中，运行在一个处理器上的一个程序实例称为( )\", \"len\": 2, \"1\": \"进程\", \"0\": \"线程\"}','A','',3),(266,0,'{\"title\": \"（ ）为程序员提供了一种机制，将程序划分为多个大致独立的任务，当某个任务阻塞时能执行其他任 务。\", \"len\": 3, \"1\": \"线程\", \"0\": \"进程\", \"2\": \"接口\"}','B','',3),(267,0,'{\"len\": 4, \"1\": \"CUDA\", \"title\": \"（ ）和 OpenMP 是为共享内存系统的编程而设计的，它们提供访问共享内存的机制。\", \"3\": \"Pthreads\", \"0\": \"MPI\", \"2\": \"MapReduce\"}','D','',3),(268,0,'{\"len\": 4, \"1\": \"寄存器\", \"title\": \"CPU 中的数据和程序执行时的状态信息存储在特殊的快速存储介质中，即（ ）。\", \"3\": \"程序计数器\", \"0\": \"主存\", \"2\": \"互联结构\"}','B','',3),(269,0,'{\"len\": 4, \"1\": \"计算强度相当\", \"title\": \"在并行计算中,粗粒度的并行相对细粒度的并行来说\", \"3\": \"时间开销较小\", \"0\": \"计算强度低\", \"2\": \"较难实现负载均衡\"}','C','',3),(270,0,'{\"len\": 4, \"1\": \"共享存储并行计算模型包括 LogP 模型和 PRAM 模型\", \"title\": \"下面关于并行计算模型，哪个描述是正确的？\", \"3\": \"分布式存储并行计算模型包括 LogP 模型和 BSP 模型；\", \"0\": \"共享存储并行计算模型包括 PRAM 模型和 BSP 模型\", \"2\": \"分布式存储并行计算模型包括 PRAM 模型和 BSP 模型\"}','D','',3),(271,0,'{\"title\": \"以下哪个事例是 Vtune 性能分析器的基于事件的采样？ ( )\", \"len\": 3, \"1\": \"Every n processor ticks\", \"0\": \"Branch misprediction\", \"2\": \"Bugs encountered\"}','A','',3),(272,0,'{\"len\": 4, \"1\": \"负载平衡\", \"title\": \"一个或多个核将自己的部分和结果发送给其他的核这一过程称之为：（）\", \"3\": \"异步\", \"0\": \"通信\", \"2\": \"同步\"}','A','',3),(273,0,'{\"title\": \"如果一个进程试图接收消息，但没有相匹配的消息，那么该进程将会被永远阻塞在那里,这种情况叫做( )\", \"len\": 3, \"1\": \"进程阻\", \"0\": \"进程悬挂\", \"2\": \"进程死锁\"}','A','',3),(274,0,'{\"title\": \"如果程序可以在不增加问题规模的前提下维持恒定效率，那么程序拥有( )  扩展性\", \"len\": 2, \"1\": \"强\", \"0\": \"弱\"}','B','',3),(275,0,'{\"title\": \"在一个集合通信中，如果属于一个进程的数据被发送到通信子中的所有进程，则这样的集合通信叫做 ( )\", \"len\": 3, \"1\": \"集合通信\", \"0\": \"点对点通信\", \"2\": \"广播\"}','C','',3),(276,0,'{\"title\": \"串行时间与并行时间的比值叫做\", \"len\": 2, \"1\": \"加速比\", \"0\": \"效率\"}','B','',3),(277,0,'{\"len\": 4, \"1\": \"barrier\", \"title\": \"在并行域当中，有一段代码想用单线程执行，是使用什么关键字\", \"3\": \"master\", \"0\": \"single\", \"2\": \"atomic\"}','A','',3),(278,0,'{\"title\": \"在任何一个 MIMD 系统中，如果处理器异步执行，那么很可能会引发（ ）。\", \"len\": 3, \"1\": \"弱确定性\", \"0\": \"强确定性\", \"2\": \"非确定性\"}','C','',3),(279,0,'{\"len\": 4, \"1\": \"锁有两个操作，分别是获取锁和释放锁\", \"title\": \"对于锁，以下表述不正确的是：( )\", \"3\": \"若线程不主动放弃锁，其他线程可以抢占它\", \"0\": \"锁类似于信号量，不同之处在于在同一时刻只能使用一个锁。\", \"2\": \"互斥量是一种锁，线程对共享资源进行访问之前必须先获得锁；否则线程将保持等待状态，直到该锁可用。\"}','D','',3),(280,0,'{\"len\": 4, \"1\": \"在引入线程的操作系统中，则把线程作为 CPU  调度和分派的基本单位\", \"title\": \"以下表述不正确的是：( )\", \"3\": \"由一个进程中的线程切换到另一进程中的线程时，也不会引起进程切换\", \"0\": \"在传统的操作系统中，CPU  调度和分派的基本单位是进程\", \"2\": \"同一进程中线程的切换不会引起进程切换，从而避免了昂贵的系统调用\"}','D','',3),(281,0,'{\"len\": 4, \"1\": \"除非你已经有了一个相当清晰可靠的非优化版本的实现，否则你不要试图对程序进行优化\", \"title\": \"Jackson  优化定律是指：( )\", \"3\": \"以上两条都不是\", \"0\": \"不要进行优化\", \"2\": \"以上两条都是\"}','C','',3),(282,0,'{\"len\": 4, \"1\": \"线程是 CPU 调度和分派的基本单位\", \"title\": \"关于进程和线程的描述中不正确的是\", \"3\": \"线程必须依存在进程中，由进程提供多个线程执行的控制\", \"0\": \"进程和线程都可以独立执行\", \"2\": \"进程是系统进行资源分配和调度的一个独立单位\"}','A','',3),(283,0,'{\"len\": 4, \"1\": \"4\", \"title\": \"How many threads per core on Xeon Phi?\", \"3\": \"8\", \"0\": \"2\", \"2\": \"6\"}','B','',3),(284,0,'{\"title\": \"What\'s the purpose of huge page setting on Xeon Phi?\", \"len\": 3, \"1\": \"Improve memory bandwidth\", \"0\": \"Improve TLB hit ratio.\", \"2\": \"Improve data locality\"}','A','',3),(285,0,'{\"len\": 4, \"1\": \"512bits\", \"title\": \"How long is vector length on Xeon Phi?\", \"3\": \"64bits\", \"0\": \"128bits\", \"2\": \"256bits\"}','B','',3),(286,1,'{\"len\": 6, \"1\": \"执行终止\", \"title\": \"作为多遍优化算法 PGO 的三步过程由以下哪三步构成？( )\", \"5\": \"代码执行与评估\", \"3\": \"执行被插入信息采集代码的程序(Instrumented execution)\", \"4\": \"插入信息采集代码后编译(Instrumented compilation)\", \"0\": \"代码编译\", \"2\": \"反馈编译（feedback compilation）\"}','C;D','',3),(287,1,'{\"len\": 4, \"1\": \"concurrent_queue\", \"title\": \"以下属于 TBB 中的并行容器的是：( )\", \"3\": \"concurrent_vector\", \"0\": \"concurrent_set\", \"2\": \"concurrent_hash_map\"}','B;C;D','',3),(288,1,'{\"len\": 4, \"1\": \"进程 0 先执行 MPI_Recv 接收 M1、然后执行 MPI_Send 发送 M0，进程 1 执行 MPI_Recv 接收 M0、然后先 执行 MPI_Send 发送 M1\", \"title\": \"进程 0 要将消息 M0 发送给进程 1，进程 1 要将消息 M1 发送给进程 0。下列哪几种情况下，可能出现 “死锁”？\", \"3\": \"进程 0 先执行 MPI_IRecv 接收 M1、然后执行 MPI_Send 发送 M0，进程 1 执行 MPI_Recv 接收 M0、然后先 执行 MPI_Send 发送 M1\", \"0\": \"进程 0 先执行 MPI_Send 发送 M0、然后执行 MPI_Recv 接收 M1，进程 1 先执行 MPI_Send 发送 M1、然 后执行 MPI_Recv 接收 M0\", \"2\": \"进程 0 先执行 MPI_ISend 发送 M0、然后执行 MPI_Recv 接收 M1，进程 1 先执行 MPI_Send 发送 M1、然后 执行 MPI_Recv 接收 M0\"}','A;B;C','',3),(289,1,'{\"title\": \"避免对临界区竞争访问的基本方法有 ()\", \"len\": 3, \"1\": \"互斥量\", \"0\": \"忙等待\", \"2\": \"信号量\"}','A;B;C','',3),(290,1,'{\"len\": 4, \"1\": \"合并\", \"title\": \"如果进程是执行的“主线程”，其他线程由主线程启动和停止，那么我们可以设想进程和它的子线程如 下进行，当一个线程开始时，它从进程中（ ）出来；当一个线程结束，它（ ）到进程中。\", \"3\": \"消亡\", \"0\": \"派生\", \"2\": \"分离\"}','A;B','',3),(291,1,'{\"title\": \"下面是 MPI 可以绑定的语言的是( )\", \"len\": 3, \"1\": \"C++语言\", \"0\": \"C 语言\", \"2\": \"Fortran  语言\"}','A;B;C','',3),(292,1,'{\"len\": 4, \"1\": \"随机取样\", \"title\": \"VTune  性能分析器中的取样功能有哪几种方式？()\", \"3\": \"线性取样\", \"0\": \"基于时间取样\", \"2\": \"基于事件取样\"}','A;C','',3),(293,1,'{\"len\": 4, \"1\": \"使用原子操作来替代锁。\", \"title\": \"对于如何解决串行化方面的难题，以下表述正确的是：()\", \"3\": \"设计并行指令\", \"0\": \"少用锁，甚至采用无锁编程。\", \"2\": \"从设计和算法层面来缩小串行化所占的比例。\"}','A;B;C','',3),(294,1,'{\"title\": \"下面是 MPI 提供的拓扑是 ( )\", \"len\": 2, \"1\": \"图拓扑\", \"0\": \"笛卡儿拓扑\"}','A;B','',3),(756,3,'下列函数将一个数组A变换成另一个数组B，A和B的元素数量相同、且![](/static/upload/mdimages/20161228163737.png)。数组A和数组B已预先划分成若干个等长片段，每个片段的大小为size，第k个片段存储在通信子\\*comm的第k号进程上。在每个处理器上，数组A的本地片段的存储空间起始地址为函数参数”A”、 数组B的本地片段的存储空间起始地址为函数参数”B”。请补充缺少的代码。\r\n\r\n```\r\nvoid mysum(MPIComm *comm, int *A, int *B, int size) {\r\n  int i, rank, np, *sum;\r\n  MPICommsize(*comm, &np);\r\n  MPICommrank(*comm, &rank);  \r\n  B[0] = A[0];\r\n  for(i=1; i<size; i++) B[i] = B[i-1] + A[i];\r\n sum = new int[np];\r\n  MPIAllgather(&B[size-1], 1, MPIINT, sum, 1, MPIINT, *comm);\r\n *sum[rank] = 0;for(i=0; i<rank; i++) sum[rank] += sum[i];for(i=0; i<size; i++) B[i] += sum[rank]; *\r\n delete[] sum; \r\n}\r\n```\r\n','{\"0\":\"comm的第k号进程上。在每个处理器上，数组A的本地片段的存储空间起始地址为函数参数”A”、 数组B的本地片段的存储空间起始地址为函数参数”B”。请补充缺少的代码。\\n\\n```\\nvoid mysum(MPIComm \",\"1\":\"A, int \",\"2\":\"sum;\\n\\tMPICommsize(\",\"3\":\"comm, &rank);\\t\\n\\tB[0] = A[0];\\n\\tfor(i=1; i<size; i++) B[i] = B[i-1] + A[i];\\n\\tsum = new int[np];\\n\\tMPIAllgather(&B[size-1], 1, MPIINT, sum, 1, MPIINT, \",\"4\":\"sum[rank] = 0;for(i=0; i<rank; i++) sum[rank] += sum[i];for(i=0; i<size; i++) B[i] += sum[rank]; \",\"len\":5}','',3),(757,3,'下列程序的输出结果为：0 1 2 3 4 5 6 7 7 6 5 4 3 2 1 0。请补充缺少的代码。提示：对线程从0开始编号，先顺序输出线程编号，再逆序输出线程编号。\r\n\r\n```\r\n#include <pthread.h>\r\n#include <unistd.h>  \r\n#include <stdlib.h>  \r\n#include <stdio.h>  \r\n#define THREAD_NUM 8      \r\nint threadid = 0;\r\npthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;\r\npthread_cond_t  cond  = PTHREAD_COND_INITIALIZER;\r\nvoid *fun(void *arg) {\r\n    *缺少的代码*\r\n pthread_exit(NULL);\r\n} \r\nint main(int argc, char* argv[])  {  \r\n    int i;\r\n  pthread_t *threads;  \r\n threads = new pthread_t[THREAD_NUM];      \r\n    for(i=0; i<THREAD_NUM; i++)  pthread_create(&threads[i], NULL, fun, NULL); \r\n    for(i=0; i<THREAD_NUM; i++)  pthread_join(threads[i], NULL);\r\n    delete[] threads;\r\n    printf(\"\\n\");\r\n    return EXIT_SUCCESS;  \r\n}\r\n```\r\n','{\"0\":\"fun(void \",\"1\":\"缺少的代码\",\"2\":\" argv[])  {  \\n    int i;\\n\\tpthread_t \",\"len\":3}','',3),(758,3,'下列程序输出结果：sum=4950。请补充缺少的代码。提示：线程函数\\*fun(void \\*arg)的功能是对一个数组片段的各元素求和，并通过原子操作将计算结果规约到\\*arg中的sum分量上。\r\n\r\n```\r\n#include <pthread.h>\r\n#include <unistd.h>  \r\n#include <stdlib.h>  \r\n#include <stdio.h>        \r\nstruct Task {\r\n int *data, *sum, first, last;\r\n};\r\nvoid *fun(void *arg) {\r\n Task& task=*(Task*)arg;\r\n int sum=0, i; \r\n  for(i=task.first; i<task.last; i++) sum+=task.data[i];\r\n  __sync_fetch_and_add (task.sum, sum);\r\n pthread_exit(NULL);\r\n} \r\nint main(int argc, char* argv[])  {  \r\n    int       i, data[100], sum=0, thread_num=sysconf(_SC_NPROCESSORS_ONLN);\r\n  pthread_t *threads;  \r\n Task      *tasks; \r\n  for(i=0; i<100; i++) data[i] = i;\r\n tasks   = new Task[thread_num];\r\n threads = new pthread_t[thread_num];\r\n  *缺少的代码*\r\n    for(i=0; i<thread_num; i++)  pthread_create(&threads[i], NULL, fun, &tasks[i]); \r\n    for(i=0; i<thread_num; i++)  pthread_join(threads[i], NULL);\r\n    delete[] tasks;\r\n    delete[] threads;\r\n    printf(\"sum=%d\\n\", sum);    \r\n    return EXIT_SUCCESS;  \r\n}\r\n```\r\n','{\"0\":\"fun(void \\\\\",\"1\":\"arg中的sum分量上。\\n\\n```\\n#include <pthread.h>\\n#include <unistd.h>  \\n#include <stdlib.h>  \\n#include <stdio.h>        \\nstruct Task {\\n\\tint \",\"2\":\"sum, first, last;\\n};\\nvoid \",\"3\":\"arg) {\\n\\tTask& task=\",\"4\":\")arg;\\n\\tint sum=0, i;\\t\\n\\tfor(i=task.first; i<task.last; i++) sum+=task.data[i];\\n\\t__sync_fetch_and_add (task.sum, sum);\\n\\tpthread_exit(NULL);\\n} \\nint main(int argc, char\",\"5\":\"threads;  \\n\\tTask      \",\"6\":\"缺少的代码\",\"len\":7}','',3),(759,3,'下列函数实现数组元素求和：数组的大小为array_size，其元素全部存储在通信子\\*comm的第root号进程上，array是数组的起始地址，计算结果也返回给第root号进程。请补充缺少的代码。\r\n\r\n```\r\n#define SIZE       20 \r\n#define NOTASK     1\r\n#define NEWTASK    2  \r\nint my_sum(MPI_Comm* comm, int *array, int array_size, int root) {\r\n  MPI_Status  status;\r\n int rank, i, size, data[SIZE], val=0;\r\n MPI_Comm_rank(*comm, &rank);  \r\n  if ( rank==root ) {\r\n   *缺少的代码*\r\n }\r\n else while(1) {\r\n   MPI_Send(&val, 1, MPI_INT, root, 0, *comm);\r\n   MPI_Recv(data, SIZE, MPI_INT, root, MPI_ANY_TAG, *comm, &status);\r\n   if (status.MPI_TAG==NOTASK) break;\r\n    val = 0;\r\n    MPI_Get_count(&status, MPI_INT, &size);\r\n   for(i=0; i<size; i++) val += data[i];\r\n } \r\n}\r\n```','{\"0\":\"comm的第root号进程上，array是数组的起始地址，计算结果也返回给第root号进程。请补充缺少的代码。\\n\\n```\\n#define SIZE       20 \\n#define NOTASK     1\\n#define NEWTASK    2  \\nint my_sum(MPI_Comm\",\"1\":\"array, int array_size, int root) {\\n\\tMPI_Status  status;\\n\\tint rank, i, size, data[SIZE], val=0;\\n\\tMPI_Comm_rank(\",\"2\":\"缺少的代码\",\"3\":\"comm);\\n\\t\\tMPI_Recv(data, SIZE, MPI_INT, root, MPI_ANY_TAG, \",\"len\":4}','',3),(760,5,'在有24颗执行核的SMP/多核处理器系统上，对二维矩阵A进行2D5P模板计算，假设A的规模为2m2n，m>n>5。请设计一个并行求解算法并给出该算法的加速比上限。\r\n\r\n','','',3),(761,5,'A和B是两个单精度浮点数的矩阵，A的规模为n×m、B的规模为m×k。请问，在CUDA上实现矩阵乘法A×B时，GPU与设备内存之间的最少数据交换量为多少？假设执行配置中，线程块的笛卡尔结构为r×c。','','',3),(762,5,'矩阵A的规模是2^m×2^n、矩阵B的规模是2^n×2^k。在一个由2^2p颗处理器构成的BSP上，采用流水并行执行A×B。假设m、n、k均大于p。\r\n\r\na)  每颗处理上消耗的存储空间规模是多少？\r\n\r\nb)  要执行多少个超级计算步？\r\n\r\nc)  在计算过程中，每颗处理器总共要发送多少个数据元素？ ','','',3),(763,5,'一个无权图G的顶点数量为n、半径为α、直径为β。在一个APRAM-CRCW并行计算机上以最快速度执行BFS，请问并行计算效率的上限和下限分别是多少？假设在该APRAM-CRCW并行计算机上，一个操作内可以完成两项计算：某个顶点的状态更新计算；比较当前顶点被更新前后的状态值并将比较结果写入并行计算机的存储空间。','','',3),(764,5,'在一个由p颗处理器构成的BSP上将数组A变换成数组B，A和B都有n个元素，B的每个元素 Bi 的值是![](/static/upload/md_images/20161229234518.png)。假设p远小于n，设计一个并行求解算法并给出该算法的加速比上限。','','',3),(765,5,'在一台BSP并行计算机上，共有p颗处理器。请问：为尽可能快的完成两个长度为N的向量的点积运算，共需要执行多少个超级计算步、并简述计算超级计算步数量的依据。假设N远大于p。','','',3),(766,5,'在p颗处理器的PRAM并行计算机上对N个元素求和。请问加速比和并行计算效率分别是多少？','','',3),(767,5,'一个N-body问题中包括2^n个粒子。在一个由2^p颗处理器构成的BSP上采用分治并行计算粒子的受力，在一个时间步上要经过多少个超级计算步才能计算出一个粒子的受力？假设n大于p。','','',3),(768,5,'一个N-body问题中包括2^n个粒子。在一个由2^p颗处理器构成的SMP系统上采用流水并行计算粒子的受力。假设SMP系统上每个存储单位可以存储一个粒子的全部信息；n大于p。\r\n\r\na) 使用Pthreads编程实现，应用程序的内存开销是多少？ \r\n\r\nb) 使用MPI编程实现，应用程序的内存开销是多少？\r\n','','',3),(769,5,'假设有一个计算问题，其中串行计算量占15%。为实现并行计算，需要增加1.5%的计算量，这部分计算量是不能并行执行的，并且与所使用处理器/执行内核的数量无关。此外，每个处理器/执行内核在执行并行计算任务的过程中，还需要执行为所承担的并行任务执行一定的额外操作。这些额外操作的计算量是所承担并行任务量的0.1%。请问：\r\n\r\na) 在一个有M颗处理器/执行内核的计算平台上,并行程序可取得的最大加速比是多少？\r\n\r\nb)   为了使得并行计算效率至少为70%，M最大可为多少？\r\n','','',3),(770,5,'假设A和B是两个向量，各存储N个复数。请问执行A和B的向量乘(A的第I个元素与B的第I个元素相乘)，至少需要多少次乘法运算?','','',3);
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submit_problem`
--

DROP TABLE IF EXISTS `submit_problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `submit_problem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `code` text NOT NULL,
  `language` varchar(128) NOT NULL,
  `submit_time` datetime DEFAULT NULL,
  `status` varchar(128) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  CONSTRAINT `submit_problem_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `programs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submit_problem`
--

LOCK TABLES `submit_problem` WRITE;
/*!40000 ALTER TABLE `submit_problem` DISABLE KEYS */;
INSERT INTO `submit_problem` VALUES (1,2,3,'#include <stdio.h>\r\nint main(){\r\n    printf(\"Success!\");\r\n}','C','2016-11-06 20:36:14',NULL),(2,2,5,'#include <stdio.h>\r\nint main(){\r\n    printf(\"AAA\");\r\n}','C','2016-12-05 11:29:36',NULL),(3,2,5,'#include <stdio.h>\r\nint main(){\r\n    printf(\"AAA\");\r\n}','C','2016-12-05 11:33:42',NULL),(4,2,5,'#include <stdio.h>\r\nint main(){\r\n    printf(\"AAA\");\r\n}','C','2016-12-05 11:35:07',NULL),(5,2,5,'#include <stdio.h>\r\nint main(){\r\n    printf(\"AAA\");\r\n}','C','2016-12-05 11:35:50',NULL),(6,2,5,'#include <stdio.h>\r\nint main(){\r\n    printf(\"AAA\");\r\n}','C','2016-12-05 11:38:42',NULL),(7,2,5,'#include <stdio.h>\r\nint main(){\r\n    printf(\"AAA\");\r\n}','C','2016-12-05 11:45:08',NULL),(8,2,5,'#include <stdio.h>\r\nint main(){\r\n    printf(\"AAA\");\r\n}','C','2016-12-05 11:46:57',NULL),(9,2,9,'#include \"stdio.h\"\r\n\r\nint main()\r\n{\r\n    printf(\"hello world!\\n\");\r\n}','C','2016-12-05 14:05:39',NULL),(10,2,5,'#include <>','C','2016-12-06 16:01:43',NULL),(11,2,5,'#include <stdio.h>\r\nint main(){\r\n    printf(\"%d\", 1+2);\r\n    return 0;\r\n}','C','2016-12-06 16:02:35',NULL),(12,2,3,'#include <stdio.h>\r\nint main(){\r\n    printf(\"AAA\");\r\n}','C','2016-12-15 19:04:58',NULL),(13,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 10:12:37',NULL),(14,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 10:13:10',NULL),(15,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 10:13:25',NULL),(16,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 13:50:47',NULL),(17,4,1,'','C','2016-12-24 13:53:19',NULL),(18,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 14:05:56',NULL),(19,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 14:06:30',NULL),(20,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 14:10:58',NULL),(21,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 15:02:09',NULL),(22,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 15:02:22',NULL),(23,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 15:06:44',NULL),(24,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 15:07:09',NULL),(25,4,1,'data[status]==\'success','C','2016-12-24 15:10:59',NULL),(26,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 15:11:21',NULL),(27,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 15:11:41',NULL),(28,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 15:11:51',NULL),(29,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!   I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 15:12:57',NULL),(30,4,1,'','C','2016-12-24 15:13:10',NULL),(31,4,1,'eHPC/templates/problem/program_detail.html','C','2016-12-24 15:15:15',NULL),(32,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-24 15:16:07',NULL),(33,4,1,'#include <>','C','2016-12-25 13:49:29',NULL),(34,4,1,'@@@','C','2016-12-26 21:47:03',NULL),(35,4,1,'','C','2016-12-26 21:50:37',NULL),(36,4,1,'','C','2016-12-26 21:57:30',NULL),(37,4,1,'','C','2016-12-26 21:57:36',NULL),(38,4,1,'','C','2016-12-26 21:57:45',NULL),(39,4,1,'','C','2016-12-26 21:58:26',NULL),(40,4,1,'','C','2016-12-26 21:58:50',NULL),(41,4,1,'','C','2016-12-26 21:59:49',NULL),(42,4,1,'','C','2016-12-26 22:00:02',NULL),(43,4,1,'','C','2016-12-26 22:01:04',NULL),(44,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-26 22:01:34',NULL),(45,4,1,'','C','2016-12-26 22:07:54',NULL),(46,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-26 22:08:22',NULL),(47,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-26 22:08:34',NULL),(48,4,1,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2016-12-30 13:48:54',NULL),(49,2,3,'#include <stdio.h>\r\nint main(){\r\n    printf(\"Success!\");\r\n}\r\n','C','2017-01-03 13:12:14',NULL),(50,2,3,'#include <stdio.h>\r\nint main(){\r\n    printf(\"Success!\");\r\n}\r\n','C','2017-01-03 13:12:20',NULL),(51,2,3,'#include <stdio.h>\r\nint main(){\r\n    printf(\"Success!\");\r\n}','C','2017-01-03 13:13:08',NULL),(52,4,3,'#3','C','2017-01-03 13:14:57',NULL),(53,6,12,'#include<stdio.h>\r\nint main(){\r\n    printf(\"hello!\\n\");\r\n}','C','2017-01-03 15:24:15',NULL),(54,6,12,'#include<stdio.h>\r\nint main(){\r\n    printf(\"hello!\\n\");\r\n}','C','2017-01-03 15:24:42',NULL),(55,6,12,'#include<stdio.h>\r\nint main(){\r\n    printf(\"hello!\\n\");\r\n}','C','2017-01-03 15:29:37',NULL),(56,6,12,'#include<stdio.h>\r\nint main(){\r\n    printf(\"hello!\\n\");\r\n}','C','2017-01-03 15:30:32',NULL),(57,6,12,'#include<stdio.h>\r\nint main(){\r\n    printf(\"hello!\\n\");\r\n}','C','2017-01-03 15:32:45',NULL),(58,6,12,'#include<stdio.h>\r\nint main(){\r\n    printf(\"hello!\\n\");\r\n}','C','2017-01-03 15:33:26',NULL),(59,6,12,'#include<stdio.h>\r\nint main(){\r\n    printf(\"hello!\\n\");\r\n}','C','2017-01-03 15:34:12',NULL),(60,6,12,'#include<stdio.h>\r\nint main(){\r\n    printf(\"hello!\\n\");\r\n}','C','2017-01-03 15:37:45',NULL),(61,6,12,'#include<stdio.h>\r\nint main(){\r\n    printf(\"hello!\\n\");\r\n}','C','2017-01-03 15:41:40',NULL),(62,6,12,'#include<stdio.h>\r\nint main(){\r\n    printf(\"hello!\\n\");\r\n}','C','2017-01-03 15:41:56',NULL),(63,6,12,'#include<stdio.h>\r\nint main(){\r\n    printf(\"hello!\\n\");\r\n}','C','2017-01-03 16:06:12',NULL),(64,2,3,'#include <stdio.h>\r\nint main(){\r\n    printf(\"Success!\");\r\n}','C','2017-01-06 10:05:02',NULL),(65,2,3,'#include <stdio.h>\r\nint main(){\r\n    printf(\"Success!\");\r\n}','C','2017-01-06 10:05:10',NULL),(66,5,3,'teasta','C','2017-01-09 15:12:23',NULL),(67,6,12,'print (\"Hello\")','Python','2017-01-09 15:37:01',NULL),(68,6,12,'#include <stdio.h>\r\nint main(){\r\n    printf(\"Hello!\\n\");\r\n}','C','2017-01-09 15:37:49',NULL),(69,6,12,'#include <stdio.h>\r\n#include <mpi.h>\r\n\r\nint main(int argc , char *argv[]){\r\n    int myid , numprocs , namelen ;\r\n    char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n    MPI_Init(&argc , &argv);\r\n    MPI_Comm_rank(MPI_COMM_WORLD,&myid);\r\n    MPI_Comm_size(MPI_COMM_WORLD,&numprocs);\r\n    MPI_Get_processor_name(processor_name , &namelen);\r\n    if(myid ==0) \r\n        printf(\"number of processes: %d\\n\" , numprocs);\r\n    printf(\"%s: Hello world from process %d \\n\" ,processor_name ,myid );\r\n    printf(\"Hello!\\n\");\r\n    \r\n}','C','2017-01-09 15:52:54',NULL),(70,6,12,'#include <stdio.h>\r\n#include <mpi.h>\r\n\r\nint main(int argc , char *argv[]){\r\n    int myid , numprocs , namelen ;\r\n    char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n    MPI_Init(&argc , &argv);\r\n    MPI_Comm_rank(MPI_COMM_WORLD,&myid);\r\n    MPI_Comm_size(MPI_COMM_WORLD,&numprocs);\r\n    MPI_Get_processor_name(processor_name , &namelen);\r\n    if(myid ==0) \r\n        printf(\"number of processes: %d\\n\" , numprocs);\r\n    printf(\"%s: Hello world from process %d \\n\" ,processor_name ,myid );\r\n    printf(\"Hello!\\n\");\r\n    \r\n}','C','2017-01-09 15:58:17',NULL),(71,5,3,'testa','C','2017-01-09 16:03:01',NULL),(72,5,13,'#include<stdio.h>\r\n#include<mpi.h>\r\n\r\nint main(int argc, char **argv)\r\n{\r\n	int myrank, nproc, namelen;\r\n	char processor_name[MPI_MAX_PROCESSOR_NAME];\r\n	MPI_Init(&argc, &argv);\r\n	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);\r\n	MPI_Get_processor_name(processor_name, &namelen);\r\n\r\n	printf(\"Hello World!I\'m rank %d of %d on %s\\n\", myrank, nproc, processor_name);\r\n	MPI_Finalize();\r\n	return 0;\r\n}','C','2017-01-09 18:52:33',NULL),(73,5,3,'#include <stdio.h>\r\n\r\nmain()\r\n{\r\n    \r\n    \r\n}\r\n\r\n','C','2017-01-12 15:58:00',NULL),(74,5,3,'','ace/mode/c_cpp','2017-02-22 20:49:03',NULL),(75,1,3,'','ace/mode/c_cpp','2017-02-23 15:55:42',NULL);
/*!40000 ALTER TABLE `submit_problem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topics`
--

DROP TABLE IF EXISTS `topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `content` text NOT NULL,
  `visitNum` int(11) DEFAULT NULL,
  `postNum` int(11) DEFAULT NULL,
  `groupID` int(11) DEFAULT NULL,
  `userID` int(11) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `updatedTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `groupID` (`groupID`),
  KEY `userID` (`userID`),
  CONSTRAINT `topics_ibfk_1` FOREIGN KEY (`groupID`) REFERENCES `groups` (`id`),
  CONSTRAINT `topics_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topics`
--

LOCK TABLES `topics` WRITE;
/*!40000 ALTER TABLE `topics` DISABLE KEYS */;
INSERT INTO `topics` VALUES (1,'C++ 编译流程','简单地说，一个编译器就是一个程序，它可以阅读以某一种语言（源语言）编写的程序，并把该程序翻译成一个等价的、用另一种语言（目标语言）编写的程序。\r\n\r\nC/C++编译系统将一个程序转化为可执行程序的过程包含：\r\n\r\n* 预处理(preprocessing)：根据已放置的文件中的预处理指令来修改源文件的内容。\r\n* 编译(compilation)：通过词法分析和语法分析，在确认所有指令都是符合语法规则之后，将其翻译成等价的中间代码表示或汇编代码。\r\n* 汇编(assembly)：把汇编语言代码翻译成目标机器指令的过程。\r\n* 链接(linking)：找到所有用到的函数所在的目标文件，并把它们链接在一起合成为可执行文件(executable file)。\r\n\r\n# 预处理\r\n\r\n预处理器是在程序源文件被编译之前根据预处理指令对程序源文件进行处理的程序。**预处理器指令以#号开头标识，末尾不包含分号**。预处理命令不是C/C++语言本身的组成部分，不能直接对它们进行编译和链接。C/C++语言的一个重要功能是可以使用预处理指令和具有预处理的功能。C/C++提供的预处理功能主要有文件包含、宏替换、条件编译等。\r\n\r\n## 文件包含\r\n\r\n预处理指令 #include 用于包含头文件，有两种形式：#include <xxx.h>，#include \"xxx.h\"。\r\n\r\n尖括号形式表示被包含的文件在系统目录中。如果被包含的文件不一定在系统目录中，应该用双引号形式。在双引号形式中可以指出文件路径和文件名。如果在双引号中没有给出绝对路径，则默认为用户当前目录中的文件，此时系统首先在用户当前目录中寻找要包含的文件，若找不到再在系统目录中查找。\r\n\r\n对于用户自己编写的头文件，宜用双引号形式。对于系统提供的头文件，既可以用尖括号形式，也可以用双引号形式，都能找到被包含的文件，但显然用尖括号形式更直截了当，效率更高。\r\n\r\n## 宏替换\r\n\r\n`宏定义`：一般用一个短的名字代表一个长的代码序列。宏定义包括无参数宏定义和带参数宏定义两类。宏名和宏参数所代表的代码序列可以是任何意义的内容，如类型、常量、变量、操作符、表达式、语句、函数、代码块等。\r\n\r\n宏定义在源文件中必须单独另起一行，换行符是宏定义的结束标志，因此宏定义以换行结束，不需要分号等符号作分隔符。如果一个宏定义中代码序列太长，一行不够时，可采用续行的方法。续行是在键入回车符之前先键入符号\\，注意回车要紧接在符号\\之后，中间不能插入其它符号，当然代码序列最后一行结束时不能有\\。\r\n\r\n预处理器在处理宏定义时，会对宏进行展开（即`宏替换`）。宏替换首先将源文件中在宏定义随后所有出现的宏名均用其所代表的代码序列替换之，如果是带参数宏则接着将代码序列中的宏形参名替换为宏实参名。宏替换只作代码字符序列的替换工作，不作任何语法的检查，也不作任何的中间计算，一切其它操作都要在替换完后才能进行。如果宏定义不当，错误要到预处理之后的编译阶段才能发现。\r\n\r\n## 条件编译\r\n\r\n一般情况下，在进行编译时对源程序中的每一行都要编译，但是有时希望程序中某一部分内容只在满足一定条件时才进行编译，如果不满足这个条件，就不编译这部分内容，这就是`条件编译`。\r\n\r\n条件编译主要是进行编译时进行有选择的挑选，注释掉一些指定的代码，以达到多个版本控制、防止对文件重复包含的功能。if, #ifndef, #ifdef, #else, #elif, #endif是比较常见条件编译预处理指令，可根据表达式的值或某个特定宏是否被定义来确定编译条件。\r\n\r\n此外，还有 #pragma 指令，它的作用是设定编译器的状态或指示编译器完成一些特定的动作。\r\n\r\n# 编译\r\n\r\n编译过程的第一个步骤称为词法分析（lexical analysis）或扫描（scanning），词法分析器读入组成源程序的字符流，并且将它们组织成有意义的词素的序列，对于每个词素，词法分析器产生一个词法单元（token），传给下一个步骤：语法分析。\r\n\r\n语法分析（syntax analysis）或解析（parsing）是编译的第二个步骤，使用词法单元来创建树形的中间表示，该中间表示给出了词法分析产生的词法单元流的语法结构。一个常用的表示方法是语法树（syntax tree），树中每个内部结点表示一个运算，而该结点的子结点表示该运算的分量。\r\n\r\n接下来是语义分析（semantic analyzer），使用语法树和符号表中的信息来检测源程序是否和语言定义的语义一致。\r\n\r\n在源程序的语法分析和语义分析之后，生成一个明确的低级的或者类机器语言的中间表示。接下来一般会有一个机器无关的代码优化步骤，试图改进中间代码，以便生成更好的目标代码。\r\n\r\n# 汇编\r\n\r\n对于被翻译系统处理的每一个C/C++语言源程序，都将最终经过这一处理而得到相应的目标文件。目标文件中所存放的也就是与源程序等效的目标机器语言代码。目标文件由段组成，通常一个目标文件中至少有两个段：代码段和数据段。\r\n\r\n* 代码段：该段中所包含的主要是程序的指令。该段一般是可读和可执行的，但一般却不可写。\r\n* 数据段：主要存放程序中要用到的各种全局变量或静态的数据。一般数据段都是可读，可写，可执行的。\r\n\r\n# 链接\r\n\r\n链接程序的主要工作就是将有关的目标文件彼此相连接，也即将在一个文件中引用的符号同该符号在另外一个文件中的定义连接起来，使得所有的这些目标文件成为一个能够按操作系统装入执行的统一整体。主要有静态链接和动态链接两种方式：\r\n\r\n* `静态链接`：在链接阶段，会将汇编生成的目标文件.o与引用到的库一起链接打包到可执行文件中，程序运行的时候不再需要静态库文件。\r\n* `动态链接`：把调用的函数所在文件模块（DLL）和调用函数在文件中的位置等信息链接进目标程序，程序运行的时候再从DLL中寻找相应函数代码，因此需要相应DLL文件的支持。  \r\n\r\n这里的库是写好的现有的，成熟的，可以复用的代码。现实中每个程序都要依赖很多基础的底层库，不可能每个人的代码都从零开始，因此库的存在意义非同寻常。本质上来说库是一种可执行代码的二进制形式，可以被操作系统载入内存执行。库有两种：静态库（.a、.lib）和动态库（.so、.dll），所谓静态、动态是指链接方式的不同。\r\n\r\n静态链接库与动态链接库都是**共享代码**的方式。如果采用静态链接库，程序在运行时与函数库再无瓜葛，移植方便。但是会浪费空间和资源，因为所有相关的目标文件与牵涉到的函数库被链接合成一个可执行文件。此外，静态库对程序的更新、部署和发布也会带来麻烦。如果静态库更新了，所有使用它的应用程序都需要重新编译、发布给用户。\r\n\r\n动态库在程序编译时并不会被连接到目标代码中，而是在程序运行是才被载入。不同的应用程序如果调用相同的库，那么在内存里只需要有一份该共享库的实例，规避了空间浪费问题。动态库在程序运行是才被载入，也解决了静态库对程序的更新、部署和发布页会带来麻烦。用户只需要更新动态库即可，增量更新。\r\n\r\n此外，还要注意静态链接库中不能再包含其他的动态链接库或者静态库，而在动态链接库中还可以再包含其他的动态或静态链接库。\r\n\r\n# 简单的例子\r\n\r\n下面是一个保存在文件 helloworld.cpp 中一个简单的 C++ 程序的代码：\r\n\r\n    /* helloworld.cpp */\r\n    #include <iostream>\r\n    int main(int argc,char *argv[])\r\n    {\r\n        std::cout << \"hello, world\" << std::endl;\r\n        return 0;\r\n    }\r\n\r\n用下面命令编译：\r\n\r\n    $ g++ helloworld.cpp\r\n\r\n编译器 g++ 通过检查命令行中指定的文件的后缀名可识别其为 C++ 源代码文件。编译器默认的动作：编译源代码文件生成对象文件(object file)，链接对象文件和 libstd c++ 库中的函数得到可执行程序，然后删除对象文件。由于命令行中未指定可执行程序的文件名，编译器采用默认的 a.out。\r\n\r\n## 预处理\r\n\r\n选项 -E 使 g++ 将源代码用编译预处理器处理后不再执行其他动作。下面的命令预处理源码文件 helloworld.cpp，并将结果保存在 .ii 文件中：\r\n\r\n    ➜  ~  g++ -E helloworld.cpp -o helloworld.ii\r\n    ➜  ~  ls | grep helloworld\r\n    helloworld.cpp\r\n    helloworld.ii\r\n    ➜  ~  wc -l helloworld.ii\r\n       38126 helloworld.ii\r\n\r\nhelloworld.cpp 的源代码，仅仅有六行，而且该程序除了显示一行文字外什么都不做，但是，预处理后的版本将超过3万行。这主要是因为头文件 iostream 被包含进来，而且它又包含了其他的头文件，除此之外，还有若干个处理输入和输出的类的定义。\r\n\r\n## 编译\r\n\r\n选项 -S 指示编译器将程序编译成汇编代码，输出汇编语言代码而后结束。下面的命令将由 C++ 源码文件生成汇编语言文件 helloworld.s，生成的汇编语言依赖于编译器的目标平台。\r\n\r\n    g++ -S helloworld.cpp\r\n\r\n## 汇编\r\n\r\n选项 -c 用来告诉编译器将汇编代码（.s文件，或者直接对源代码）转换为目标文件，但不要执行链接。输出结果为对象文件，文件默认名与源码文件名相同，只是将其后缀变为 .o。\r\n\r\n    ➜  ~  g++ -c helloworld.s\r\n    ➜  ~  ls |grep helloworld.o\r\n    helloworld.o\r\n\r\n\r\n## 链接\r\n\r\n加载相应的库，执行链接操作，将对象文件（.o，也可以直接将原文件）转化成可执行程序。\r\n\r\n    ➜  ~  g++ helloworld.o -o helloworld.o\r\n    ➜  ~  ./helloworld.o\r\n    hello, world\r\n\r\n\r\n# 更多阅读\r\n  \r\n[详解C/C++预处理器](http://blog.csdn.net/huang_xw/article/details/7648117)  \r\n[Compiling Cpp](http://wiki.ubuntu.org.cn/Compiling_Cpp)  \r\n[C++静态库与动态库](http://www.cnblogs.com/skynet/p/3372855.html)  \r\n[高级语言的编译：链接及装载过程介绍](http://tech.meituan.com/linker.html)    \r\n[编译原理 (预处理>编译>汇编>链接)](http://www.cnblogs.com/pipicfan/archive/2012/07/10/2583910.html)  \r\n\r\n',23,12,1,1,'2016-09-20 00:00:00','2016-10-16 00:07:07'),(2,'C++ 声明还是定义?','简单来说：\r\n\r\n> Declaration is for the compiler to accept a name(to tell the compiler that the name is legal, the name is introduced with intention not a typo).   \r\n>\r\n> A variable is declared when the compiler is informed that a variable exists (and this is its type); it does not allocate the storage for the variable at that point.\r\n>   \r\n> Definition is where a name and its content is associated. The definition is used by the linker to link a name reference to the content of the name.  \r\n> \r\n>A variable is defined when the compiler allocates the storage for the variable.\r\n\r\n变量声明（declaration）用来引入标识符，并对它的类型（对象，函数等）进行说明，有了声明语句，`编译器`就可以理解对该标识符的引用。下面的这些都是声明语句：\r\n\r\n    extern int bar;\r\n    extern int g(int, int);\r\n    double f(int, double); // extern can be omitted for function declarations\r\n    class foo; // no extern allowed for type declarations\r\n\r\n可以重复声明一个变量，所以下面语句是合法的：\r\n\r\n    double f(int, double);\r\n    double f(int, double);\r\n    extern double f(int, double); // the same as the two above\r\n    extern double f(int, double);\r\n\r\n变量定义（definition）**用于为变量分配存储空间，还可为变量指定初始值**。可以将定义看作是对声明的变量进行实例化，`链接器`需要根据定义来找到变量具体对应的值。下面是前面声明语句对应的定义部分：\r\n\r\n    int bar;\r\n    int g(int lhs, int rhs) {return lhs*rhs;}\r\n    double f(int i, double d) {return i+d;}\r\n    class foo {};\r\n\r\n程序中，变量必须有且仅有一个定义。\r\n\r\n> No translation unit shall contain more than one definition of any variable, function, class type, enumeration type, or template.\r\n\r\n重复定义会导致链接器不知道哪一个是需要的，编译器会报错：`redefinition of`。变量缺少定义链接器会因为 `symbol(s) not found` 链接失败。下面代码片段中 b 没有定义，c重复定义：\r\n\r\n    extern int a;\r\n    extern int b;\r\n    \r\n    int main(){\r\n        int a;\r\n        cout << a << b;\r\n        int c;\r\n        int c;\r\n    }\r\n\r\n有时候区别声明和定义还真不是那么简单的，看下面的例子：\r\n\r\n```c++\r\nstruct Test\r\n{\r\n    Test(int) {}\r\n    Test() {}\r\n    void fun() {}\r\n};\r\nvoid main( void )\r\n{\r\n    Test a(1);  // 定义了一个对象\r\n    a.fun();    // 调用对象的函数 \r\n    Test b();   // 声明了一个函数\r\n    // b.fun();    // Error！！！\r\n}\r\n```',7,9,1,1,'2016-09-20 00:00:00','2016-10-19 14:32:14'),(3,'C++左值还是右值','左值与右值这两概念是从 c 中传承而来的，在 c 中，左值指的是既能够出现在等号左边也能出现在等号右边的变量(或表达式)，右值指的则是只能出现在等号右边的变量(或表达式)。\n\n\n	int a;\n	int b;\n    	\n	a = 3;\n	b = 4;\n	a = b;\n	b = a;\n 	   \n	// 以下写法不合法。\n	3 = a;\n	a+b = 4;\n\n\n在 C 语言中，通常来说有名字的变量就是左值(如上面例子中的 a, b)，而由运算操作(加减乘除，函数调用返回值等)所产生的中间结果(没有名字)就是右值，如上的 3 + 4， a + b 等。可以认为**左值就是在程序中能够寻址的东西，右值就是没法取到它的地址的东西**。\n\n如上概念到了 c++ 中，就变得稍有不同。具体来说，在 c++ 中，`每一个表达式或者是一个左值，或者是一个右值`，相应的，该表达式也就被称作“左值表达式\"，\"右值表达式\"。对于内置的基本数据类型来说(primitive types)，左值右值的概念和 c 没有太多不同，不同的地方在于自定义的类型:\n\n* 对于内置的类型，右值是不可被修改的(non-modifiable)，也不可被 const, volatile 所修饰；\n* 对于自定义的类型(user-defined types)，右值却允许通过它的成员函数进行修改。\n\nC++ 中自定义类型允许有成员函数，而通过右值调用成员函数是被允许的，但成员函数有可能不是 const 类型，因此通过调用右值的成员函数，也就可能会修改了该右值。此外，**右值只能被 const 类型的 reference 所指向**，当一个右值被 const reference 指向时，它的生命周期就被延长了。\n\n具体示例在 [C++_LR_Value](../Coding/C++_LR_Value.cpp)。\n',4,7,3,1,'2016-10-12 00:00:00','2016-10-10 00:00:00'),(4,'引用','\n引用（reference）是c++对c语言的重要扩充，引用就是某一变量（目标）的一个别名，对引用的操作与对变量直接操作完全一样。引用是除指针外另一个可以产生多态效果的手段。这意味着，一个基类的引用可以指向它的派生类实例。引用的定义方法：\n\n    类型标识符 &引用名=目标变量名；\n\n类型标识符是指目标变量的类型，这里的 & 不是求地址运算，而是起标识作用。**在定义引用时，必须同时对其进行初始化**，引用定义完毕后，相当于目标变量名有两个名称，即该目标原名称和引用名，且不能再将该引用指向其它变量。\n\n    int a=2,\n    int &ra=a;\n\na为原变量名称，ra为引用名。给ra赋值：ra=1; 等价于 a=1。对引用求地址，就是对目标变量求地址，因此&ra与&a相等。注意我们**不能建立引用的数组**，因为数组是一个由若干个元素所组成的集合，所以无法建立一个由引用组成的集合。\n\n    int& ref[3]= {2,3,5}; //int& ref[3]= {2,3,5}; //不能声明引用的数组\n    const int (&ref)[3] ={2,3,5};                 // 可以\n\n编译器一般将引用实现为`const指针`，即指向位置不可变的指针，也就是说引用实际上与一般指针同样占用内存，不过我们没有办法获得这个指针的地址。\n',19,6,4,1,'2016-10-10 00:00:00','2016-01-20 00:00:00'),(5,'失败的多态？','下面多态函数调用的输出？\r\n\r\n```\r\nclass B\r\n{\r\npublic:\r\n    virtual void vfun(int i = 10){\r\n        cout << \"B:vfun \" << i << endl;\r\n    }\r\n};\r\n\r\nclass D : public B\r\n{\r\npublic:\r\n    virtual void vfun(int i = 20){\r\n        cout << \"D:vfun \" << i << endl;\r\n    }\r\n};\r\n\r\nint main()\r\n{\r\n    D* pD = new D();\r\n    B* pB = pD;\r\n    pD->vfun();     // D:vfun 20\r\n    pB->vfun();     // D:vfun 10\r\n}\r\n```\r\n\r\n为了解释清楚，先来看四个概念：\r\n\r\n* 对象的静态类型：对象在声明时采用的类型，是在编译期确定的。\r\n* 对象的动态类型：目前所指对象的类型，是在运行期决定的。对象的动态类型可以更改，但是静态类型无法更改。\r\n* 静态绑定：绑定的是对象的静态类型，某些特性依赖于对象的静态类型，发生在编译期。\r\n* 动态绑定：绑定的是对象的动态类型，某些特性（比如多态）依赖于对象的动态类型，发生在运行期。\r\n\r\n假设类B是一个基类，类C继承B，类D继承B，那么：\r\n\r\n    D* pD = new D();//pD的静态类型是它声明的类型D*，动态类型也是D*\r\n    B* pB = pD;     //pB的静态类型是它声明的类型B*，动态类型是pB所指向的对象pD的类型D*\r\n    C* pC = new C();  \r\n    pB = pC;        //pB的动态类型是可以更改的，现在它的动态类型是C*\r\n\r\n只有虚函数才使用的是动态绑定，其他的全部是静态绑定。当缺省参数和虚函数一起出现的时候情况有点复杂，极易出错。虚函数是动态绑定的，但是为了执行效率，**缺省参数是静态绑定的**。\r\n\r\n所以对于上面的例子，pD->vfun()和pB->vfun()调用都是函数D::vfun()，但是缺省参数是静态绑定的，所以 pD->vfun() 时，pD的静态类型是D*，所以它的缺省参数应该是20；同理，pB->vfun()的缺省参数应该是10。\r\n\r\n不是很容易接受是吧，所以`Effective C++ 条款37：绝不要重新定义继承而来的缺省参数`。',9,3,1,1,'2016-10-16 08:24:18','2016-10-16 16:31:19'),(6,'Markdown 语法说明 (简体中文版)','\r\n*   [概述](#overview)\r\n    *   [宗旨](#philosophy)\r\n    *   [兼容 HTML](#html)\r\n    *   [特殊字符自动转换](#autoescape)\r\n*   [区块元素](#block)\r\n    *   [段落和换行](#p)\r\n    *   [标题](#header)\r\n    *   [区块引用](#blockquote)\r\n    *   [列表](#list)\r\n    *   [代码区块](#precode)\r\n    *   [分隔线](#hr)\r\n*   [区段元素](#span)\r\n    *   [链接](#link)\r\n    *   [强调](#em)\r\n    *   [代码](#code)\r\n    *   [图片](#img)\r\n*   [其它](#misc)\r\n    *   [反斜杠](#backslash)\r\n    *   [自动链接](#autolink)\r\n*   [感谢](#acknowledgement)\r\n*	[Markdown 免费编辑器](#editor)\r\n\r\n* * *\r\n\r\n<h2 id=\"overview\">概述</h2>\r\n\r\n<h3 id=\"philosophy\">宗旨</h3>\r\n\r\nMarkdown 的目标是实现「易读易写」。\r\n\r\n可读性，无论如何，都是最重要的。一份使用 Markdown 格式撰写的文件应该可以直接以纯文本发布，并且看起来不会像是由许多标签或是格式指令所构成。Markdown 语法受到一些既有 text-to-HTML 格式的影响，包括 [Setext] [1]、[atx] [2]、[Textile] [3]、[reStructuredText] [4]、[Grutatext] [5] 和 [EtText] [6]，而最大灵感来源其实是纯文本电子邮件的格式。\r\n\r\n  [1]: http://docutils.sourceforge.net/mirror/setext.html\r\n  [2]: http://www.aaronsw.com/2002/atx/\r\n  [3]: http://textism.com/tools/textile/\r\n  [4]: http://docutils.sourceforge.net/rst.html\r\n  [5]: http://www.triptico.com/software/grutatxt.html\r\n  [6]: http://ettext.taint.org/doc/\r\n\r\n总之， Markdown 的语法全由一些符号所组成，这些符号经过精挑细选，其作用一目了然。比如：在文字两旁加上星号，看起来就像\\*强调\\*。Markdown 的列表看起来，嗯，就是列表。Markdown 的区块引用看起来就真的像是引用一段文字，就像你曾在电子邮件中见过的那样。\r\n\r\n<h3 id=\"html\">兼容 HTML</h3>\r\n\r\nMarkdown 语法的目标是：成为一种适用于网络的*书写*语言。\r\n\r\nMarkdown 不是想要取代 HTML，甚至也没有要和它相近，它的语法种类很少，只对应 HTML 标记的一小部分。Markdown 的构想*不是*要使得 HTML 文档更容易书写。在我看来， HTML 已经很容易写了。Markdown 的理念是，能让文档更容易读、写和随意改。HTML 是一种*发布*的格式，Markdown 是一种*书写*的格式。就这样，Markdown 的格式语法只涵盖纯文本可以涵盖的范围。\r\n\r\n不在 Markdown 涵盖范围之内的标签，都可以直接在文档里面用 HTML 撰写。不需要额外标注这是 HTML 或是 Markdown；只要直接加标签就可以了。\r\n\r\n要制约的只有一些 HTML 区块元素――比如 `<div>`、`<table>`、`<pre>`、`<p>` 等标签，必须在前后加上空行与其它内容区隔开，还要求它们的开始标签与结尾标签不能用制表符或空格来缩进。Markdown 的生成器有足够智能，不会在 HTML 区块标签外加上不必要的 `<p>` 标签。\r\n\r\n例子如下，在 Markdown 文件里加上一段 HTML 表格：\r\n\r\n    这是一个普通段落。\r\n\r\n    <table>\r\n        <tr>\r\n            <td>Foo</td>\r\n        </tr>\r\n    </table>\r\n\r\n    这是另一个普通段落。\r\n\r\n请注意，在 HTML 区块标签间的 Markdown 格式语法将不会被处理。比如，你在 HTML 区块内使用 Markdown 样式的`*强调*`会没有效果。\r\n\r\nHTML 的区段（行内）标签如 `<span>`、`<cite>`、`<del>` 可以在 Markdown 的段落、列表或是标题里随意使用。依照个人习惯，甚至可以不用 Markdown 格式，而直接采用 HTML 标签来格式化。举例说明：如果比较喜欢 HTML 的 `<a>` 或 `<img>` 标签，可以直接使用这些标签，而不用 Markdown 提供的链接或是图像标签语法。\r\n\r\n和处在 HTML 区块标签间不同，Markdown 语法在 HTML 区段标签间是有效的。\r\n\r\n<h3 id=\"autoescape\">特殊字符自动转换</h3>\r\n\r\n在 HTML 文件中，有两个字符需要特殊处理： `<` 和 `&` 。 `<` 符号用于起始标签，`&` 符号则用于标记 HTML 实体，如果你只是想要显示这些字符的原型，你必须要使用实体的形式，像是 `&lt;` 和 `&amp;`。\r\n\r\n`&` 字符尤其让网络文档编写者受折磨，如果你要打「`AT&T`」 ，你必须要写成「`AT&amp;T`」。而网址中的 `&` 字符也要转换。比如你要链接到：\r\n\r\n    http://images.google.com/images?num=30&q=larry+bird\r\n\r\n你必须要把网址转换写为：\r\n\r\n    http://images.google.com/images?num=30&amp;q=larry+bird\r\n\r\n才能放到链接标签的 `href` 属性里。不用说也知道这很容易忽略，这也可能是 HTML 标准检验所检查到的错误中，数量最多的。\r\n\r\nMarkdown 让你可以自然地书写字符，需要转换的由它来处理好了。如果你使用的 `&` 字符是 HTML 字符实体的一部分，它会保留原状，否则它会被转换成 `&amp`;。\r\n\r\n所以你如果要在文档中插入一个版权符号 `©`，你可以这样写：\r\n\r\n    &copy;\r\n\r\nMarkdown 会保留它不动。而若你写：\r\n\r\n    AT&T\r\n\r\nMarkdown 就会将它转为：\r\n\r\n    AT&amp;T\r\n\r\n类似的状况也会发生在 `<` 符号上，因为 Markdown 允许 [兼容 HTML](#html) ，如果你是把 `<` 符号作为 HTML 标签的定界符使用，那 Markdown 也不会对它做任何转换，但是如果你写：\r\n\r\n    4 < 5\r\n\r\nMarkdown 将会把它转换为：\r\n\r\n    4 &lt; 5\r\n\r\n不过需要注意的是，code 范围内，不论是行内还是区块， `<` 和 `&` 两个符号都*一定*会被转换成 HTML 实体，这项特性让你可以很容易地用 Markdown 写 HTML code （和 HTML 相对而言， HTML 语法中，你要把所有的 `<` 和 `&` 都转换为 HTML 实体，才能在 HTML 文件里面写出 HTML code。）\r\n\r\n* * *\r\n\r\n<h2 id=\"block\">区块元素</h2>\r\n\r\n\r\n<h3 id=\"p\">段落和换行</h3>\r\n\r\n一个 Markdown 段落是由一个或多个连续的文本行组成，它的前后要有一个以上的空行（空行的定义是显示上看起来像是空的，便会被视为空行。比方说，若某一行只包含空格和制表符，则该行也会被视为空行）。普通段落不该用空格或制表符来缩进。\r\n\r\n「由一个或多个连续的文本行组成」这句话其实暗示了 Markdown 允许段落内的强迫换行（插入换行符），这个特性和其他大部分的 text-to-HTML 格式不一样（包括 Movable Type 的「Convert Line Breaks」选项），其它的格式会把每个换行符都转成 `<br />` 标签。\r\n\r\n如果你*确实*想要依赖 Markdown 来插入 `<br />` 标签的话，在插入处先按入两个以上的空格然后回车。\r\n\r\n的确，需要多费点事（多加空格）来产生 `<br />` ，但是简单地「每个换行都转换为 `<br />`」的方法在 Markdown 中并不适合， Markdown 中 email 式的 [区块引用][bq] 和多段落的 [列表][l] 在使用换行来排版的时候，不但更好用，还更方便阅读。\r\n\r\n  [bq]: #blockquote\r\n  [l]:  #list\r\n\r\n<h3 id=\"header\">标题</h3>\r\n\r\nMarkdown 支持两种标题的语法，类 [Setext] [1] 和类 [atx] [2] 形式。\r\n\r\n类 Setext 形式是用底线的形式，利用 `=` （最高阶标题）和 `-` （第二阶标题），例如：\r\n\r\n    This is an H1\r\n    =============\r\n\r\n    This is an H2\r\n    -------------\r\n\r\n任何数量的 `=` 和 `-` 都可以有效果。\r\n\r\n类 Atx 形式则是在行首插入 1 到 6 个 `#` ，对应到标题 1 到 6 阶，例如：\r\n\r\n    # 这是 H1\r\n\r\n    ## 这是 H2\r\n\r\n    ###### 这是 H6\r\n\r\n你可以选择性地「闭合」类 atx 样式的标题，这纯粹只是美观用的，若是觉得这样看起来比较舒适，你就可以在行尾加上 `#`，而行尾的 `#` 数量也不用和开头一样（行首的井字符数量决定标题的阶数）：\r\n\r\n    # 这是 H1 #\r\n\r\n    ## 这是 H2 ##\r\n\r\n    ### 这是 H3 ######\r\n\r\n\r\n<h3 id=\"blockquote\">区块引用 Blockquotes</h3>\r\n\r\nMarkdown 标记区块引用是使用类似 email 中用 `>` 的引用方式。如果你还熟悉在 email 信件中的引言部分，你就知道怎么在 Markdown 文件中建立一个区块引用，那会看起来像是你自己先断好行，然后在每行的最前面加上 `>` ：\r\n\r\n    > This is a blockquote with two paragraphs. Lorem ipsum dolor sit amet,\r\n    > consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.\r\n    > Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus.\r\n    > \r\n    > Donec sit amet nisl. Aliquam semper ipsum sit amet velit. Suspendisse\r\n    > id sem consectetuer libero luctus adipiscing.\r\n效果就像：\r\n> This is a blockquote with two paragraphs. Lorem ipsum dolor sit amet,\r\n> consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.\r\n> Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus.\r\n> \r\n> Donec sit amet nisl. Aliquam semper ipsum sit amet velit. Suspendisse\r\n> id sem consectetuer libero luctus adipiscing.\r\n\r\nMarkdown 也允许你偷懒只在整个段落的第一行最前面加上 `>` ：\r\n\r\n    > This is a blockquote with two paragraphs. Lorem ipsum dolor sit amet,\r\n    consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.\r\n    Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus.\r\n\r\n    > Donec sit amet nisl. Aliquam semper ipsum sit amet velit. Suspendisse\r\n    id sem consectetuer libero luctus adipiscing.\r\n\r\n区块引用可以嵌套（例如：引用内的引用），只要根据层次加上不同数量的 `>` ：\r\n\r\n    > This is the first level of quoting.\r\n    >\r\n    > > This is nested blockquote.\r\n    >\r\n    > Back to the first level.\r\n\r\n引用的区块内也可以使用其他的 Markdown 语法，包括标题、列表、代码区块等：\r\n\r\n	> ## 这是一个标题。\r\n	> \r\n	> 1.   这是第一行列表项。\r\n	> 2.   这是第二行列表项。\r\n	> \r\n	> 给出一些例子代码：\r\n	> \r\n	>     return shell_exec(\"echo $input | $markdown_script\");\r\n\r\n任何像样的文本编辑器都能轻松地建立 email 型的引用。例如在 BBEdit 中，你可以选取文字后然后从选单中选择*增加引用阶层*。\r\n\r\n<h3 id=\"list\">列表</h3>\r\n\r\nMarkdown 支持有序列表和无序列表。\r\n\r\n无序列表使用星号、加号或是减号作为列表标记：\r\n\r\n    *   Red\r\n    *   Green\r\n    *   Blue\r\n\r\n等同于：\r\n\r\n    +   Red\r\n    +   Green\r\n    +   Blue\r\n\r\n也等同于：\r\n\r\n    -   Red\r\n    -   Green\r\n    -   Blue\r\n\r\n有序列表则使用数字接着一个英文句点：\r\n\r\n    1.  Bird\r\n    2.  McHale\r\n    3.  Parish\r\n\r\n很重要的一点是，你在列表标记上使用的数字并不会影响输出的 HTML 结果，上面的列表所产生的 HTML 标记为：\r\n\r\n    <ol>\r\n    <li>Bird</li>\r\n    <li>McHale</li>\r\n    <li>Parish</li>\r\n    </ol>\r\n\r\n如果你的列表标记写成：\r\n\r\n    1.  Bird\r\n    1.  McHale\r\n    1.  Parish\r\n\r\n或甚至是：\r\n\r\n    3. Bird\r\n    1. McHale\r\n    8. Parish\r\n\r\n你都会得到完全相同的 HTML 输出。重点在于，你可以让 Markdown 文件的列表数字和输出的结果相同，或是你懒一点，你可以完全不用在意数字的正确性。\r\n\r\n如果你使用懒惰的写法，建议第一个项目最好还是从 1. 开始，因为 Markdown 未来可能会支持有序列表的 start 属性。\r\n\r\n列表项目标记通常是放在最左边，但是其实也可以缩进，最多 3 个空格，项目标记后面则一定要接着至少一个空格或制表符。\r\n\r\n要让列表看起来更漂亮，你可以把内容用固定的缩进整理好：\r\n\r\n    *   Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\r\n        Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,\r\n        viverra nec, fringilla in, laoreet vitae, risus.\r\n    *   Donec sit amet nisl. Aliquam semper ipsum sit amet velit.\r\n        Suspendisse id sem consectetuer libero luctus adipiscing.\r\n\r\n但是如果你懒，那也行：\r\n\r\n    *   Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\r\n    Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,\r\n    viverra nec, fringilla in, laoreet vitae, risus.\r\n    *   Donec sit amet nisl. Aliquam semper ipsum sit amet velit.\r\n    Suspendisse id sem consectetuer libero luctus adipiscing.\r\n\r\n如果列表项目间用空行分开，在输出 HTML 时 Markdown 就会将项目内容用 `<p>` \r\n标签包起来，举例来说：\r\n\r\n    *   Bird\r\n    *   Magic\r\n\r\n会被转换为：\r\n\r\n    <ul>\r\n    <li>Bird</li>\r\n    <li>Magic</li>\r\n    </ul>\r\n\r\n但是这个：\r\n\r\n    *   Bird\r\n\r\n    *   Magic\r\n\r\n会被转换为：\r\n\r\n    <ul>\r\n    <li><p>Bird</p></li>\r\n    <li><p>Magic</p></li>\r\n    </ul>\r\n\r\n列表项目可以包含多个段落，每个项目下的段落都必须缩进 4 个空格或是 1 个制表符：\r\n\r\n    1.  This is a list item with two paragraphs. Lorem ipsum dolor\r\n        sit amet, consectetuer adipiscing elit. Aliquam hendrerit\r\n        mi posuere lectus.\r\n\r\n        Vestibulum enim wisi, viverra nec, fringilla in, laoreet\r\n        vitae, risus. Donec sit amet nisl. Aliquam semper ipsum\r\n        sit amet velit.\r\n\r\n    2.  Suspendisse id sem consectetuer libero luctus adipiscing.\r\n\r\n如果你每行都有缩进，看起来会看好很多，当然，再次地，如果你很懒惰，Markdown 也允许：\r\n\r\n    *   This is a list item with two paragraphs.\r\n\r\n        This is the second paragraph in the list item. You\'re\r\n    only required to indent the first line. Lorem ipsum dolor\r\n    sit amet, consectetuer adipiscing elit.\r\n\r\n    *   Another item in the same list.\r\n\r\n如果要在列表项目内放进引用，那 `>` 就需要缩进：\r\n\r\n    *   A list item with a blockquote:\r\n\r\n        > This is a blockquote\r\n        > inside a list item.\r\n\r\n如果要放代码区块的话，该区块就需要缩进*两次*，也就是 8 个空格或是 2 个制表符：\r\n\r\n    *   一列表项包含一个列表区块：\r\n\r\n            <代码写在这>\r\n\r\n\r\n当然，项目列表很可能会不小心产生，像是下面这样的写法：\r\n\r\n    1986. What a great season.\r\n\r\n换句话说，也就是在行首出现*数字-句点-空白*，要避免这样的状况，你可以在句点前面加上反斜杠。\r\n\r\n    1986\\. What a great season.\r\n\r\n<h3 id=\"precode\">代码区块</h3>\r\n\r\n和程序相关的写作或是标签语言原始码通常会有已经排版好的代码区块，通常这些区块我们并不希望它以一般段落文件的方式去排版，而是照原来的样子显示，Markdown 会用 `<pre>` 和 `<code>` 标签来把代码区块包起来。\r\n\r\n要在 Markdown 中建立代码区块很简单，只要简单地缩进 4 个空格或是 1 个制表符就可以，例如，下面的输入：\r\n\r\n    这是一个普通段落：\r\n\r\n        这是一个代码区块。\r\n\r\nMarkdown 会转换成：\r\n\r\n    <p>这是一个普通段落：</p>\r\n\r\n    <pre><code>这是一个代码区块。\r\n    </code></pre>\r\n\r\n这个每行一阶的缩进（4 个空格或是 1 个制表符），都会被移除，例如：\r\n\r\n    Here is an example of AppleScript:\r\n\r\n        tell application \"Foo\"\r\n            beep\r\n        end tell\r\n\r\n会被转换为：\r\n\r\n    <p>Here is an example of AppleScript:</p>\r\n\r\n    <pre><code>tell application \"Foo\"\r\n        beep\r\n    end tell\r\n    </code></pre>\r\n\r\n一个代码区块会一直持续到没有缩进的那一行（或是文件结尾）。\r\n\r\n在代码区块里面， `&` 、 `<` 和 `>` 会自动转成 HTML 实体，这样的方式让你非常容易使用 Markdown 插入范例用的 HTML 原始码，只需要复制贴上，再加上缩进就可以了，剩下的 Markdown 都会帮你处理，例如：\r\n\r\n        <div class=\"footer\">\r\n            &copy; 2004 Foo Corporation\r\n        </div>\r\n\r\n会被转换为：\r\n\r\n    <pre><code>&lt;div class=\"footer\"&gt;\r\n        &amp;copy; 2004 Foo Corporation\r\n    &lt;/div&gt;\r\n    </code></pre>\r\n\r\n代码区块中，一般的 Markdown 语法不会被转换，像是星号便只是星号，这表示你可以很容易地以 Markdown 语法撰写 Markdown 语法相关的文件。\r\n\r\n<h3 id=\"hr\">分隔线</h3>\r\n\r\n你可以在一行中用三个以上的星号、减号、底线来建立一个分隔线，行内不能有其他东西。你也可以在星号或是减号中间插入空格。下面每种写法都可以建立分隔线：\r\n\r\n    * * *\r\n\r\n    ***\r\n\r\n    *****\r\n\r\n    - - -\r\n\r\n    ---------------------------------------\r\n\r\n\r\n* * *\r\n\r\n<h2 id=\"span\">区段元素</h2>\r\n\r\n<h3 id=\"link\">链接</h3>\r\n\r\nMarkdown 支持两种形式的链接语法： *行内式*和*参考式*两种形式。\r\n\r\n不管是哪一种，链接文字都是用 [方括号] 来标记。\r\n\r\n要建立一个*行内式*的链接，只要在方块括号后面紧接着圆括号并插入网址链接即可，如果你还想要加上链接的 title 文字，只要在网址后面，用双引号把 title 文字包起来即可，例如：\r\n\r\n    This is [an example](http://example.com/ \"Title\") inline link.\r\n\r\n    [This link](http://example.net/) has no title attribute.\r\n\r\n会产生：\r\n\r\n    <p>This is <a href=\"http://example.com/\" title=\"Title\">\r\n    an example</a> inline link.</p>\r\n\r\n    <p><a href=\"http://example.net/\">This link</a> has no\r\n    title attribute.</p>\r\n\r\n如果你是要链接到同样主机的资源，你可以使用相对路径：\r\n\r\n    See my [About](/about/) page for details.   \r\n\r\n*参考式*的链接是在链接文字的括号后面再接上另一个方括号，而在第二个方括号里面要填入用以辨识链接的标记：\r\n\r\n    This is [an example][id] reference-style link.\r\n\r\n你也可以选择性地在两个方括号中间加上一个空格：\r\n\r\n    This is [an example] [id] reference-style link.\r\n\r\n接着，在文件的任意处，你可以把这个标记的链接内容定义出来：\r\n\r\n    [id]: http://example.com/  \"Optional Title Here\"\r\n\r\n链接内容定义的形式为：\r\n\r\n*   方括号（前面可以选择性地加上至多三个空格来缩进），里面输入链接文字\r\n*   接着一个冒号\r\n*   接着一个以上的空格或制表符\r\n*   接着链接的网址\r\n*   选择性地接着 title 内容，可以用单引号、双引号或是括弧包着\r\n\r\n下面这三种链接的定义都是相同：\r\n\r\n	[foo]: http://example.com/  \"Optional Title Here\"\r\n	[foo]: http://example.com/  \'Optional Title Here\'\r\n	[foo]: http://example.com/  (Optional Title Here)\r\n\r\n**请注意：**有一个已知的问题是 Markdown.pl 1.0.1 会忽略单引号包起来的链接 title。\r\n\r\n链接网址也可以用方括号包起来：\r\n\r\n    [id]: <http://example.com/>  \"Optional Title Here\"\r\n\r\n你也可以把 title 属性放到下一行，也可以加一些缩进，若网址太长的话，这样会比较好看：\r\n\r\n    [id]: http://example.com/longish/path/to/resource/here\r\n        \"Optional Title Here\"\r\n\r\n网址定义只有在产生链接的时候用到，并不会直接出现在文件之中。\r\n\r\n链接辨别标签可以有字母、数字、空白和标点符号，但是并*不*区分大小写，因此下面两个链接是一样的：\r\n\r\n	[link text][a]\r\n	[link text][A]\r\n\r\n*隐式链接标记*功能让你可以省略指定链接标记，这种情形下，链接标记会视为等同于链接文字，要用隐式链接标记只要在链接文字后面加上一个空的方括号，如果你要让 \"Google\" 链接到 google.com，你可以简化成：\r\n\r\n	[Google][]\r\n\r\n然后定义链接内容：\r\n\r\n	[Google]: http://google.com/\r\n\r\n由于链接文字可能包含空白，所以这种简化型的标记内也许包含多个单词：\r\n\r\n	Visit [Daring Fireball][] for more information.\r\n\r\n然后接着定义链接：\r\n\r\n	[Daring Fireball]: http://daringfireball.net/\r\n\r\n链接的定义可以放在文件中的任何一个地方，我比较偏好直接放在链接出现段落的后面，你也可以把它放在文件最后面，就像是注解一样。\r\n\r\n下面是一个参考式链接的范例：\r\n\r\n    I get 10 times more traffic from [Google] [1] than from\r\n    [Yahoo] [2] or [MSN] [3].\r\n\r\n      [1]: http://google.com/        \"Google\"\r\n      [2]: http://search.yahoo.com/  \"Yahoo Search\"\r\n      [3]: http://search.msn.com/    \"MSN Search\"\r\n\r\n如果改成用链接名称的方式写：\r\n\r\n    I get 10 times more traffic from [Google][] than from\r\n    [Yahoo][] or [MSN][].\r\n\r\n      [google]: http://google.com/        \"Google\"\r\n      [yahoo]:  http://search.yahoo.com/  \"Yahoo Search\"\r\n      [msn]:    http://search.msn.com/    \"MSN Search\"\r\n\r\n上面两种写法都会产生下面的 HTML。\r\n\r\n    <p>I get 10 times more traffic from <a href=\"http://google.com/\"\r\n    title=\"Google\">Google</a> than from\r\n    <a href=\"http://search.yahoo.com/\" title=\"Yahoo Search\">Yahoo</a>\r\n    or <a href=\"http://search.msn.com/\" title=\"MSN Search\">MSN</a>.</p>\r\n\r\n下面是用行内式写的同样一段内容的 Markdown 文件，提供作为比较之用：\r\n\r\n    I get 10 times more traffic from [Google](http://google.com/ \"Google\")\r\n    than from [Yahoo](http://search.yahoo.com/ \"Yahoo Search\") or\r\n    [MSN](http://search.msn.com/ \"MSN Search\").\r\n\r\n参考式的链接其实重点不在于它比较好写，而是它比较好读，比较一下上面的范例，使用参考式的文章本身只有 81 个字符，但是用行内形式的却会增加到 176 个字元，如果是用纯 HTML 格式来写，会有 234 个字元，在 HTML 格式中，标签比文本还要多。\r\n\r\n使用 Markdown 的参考式链接，可以让文件更像是浏览器最后产生的结果，让你可以把一些标记相关的元数据移到段落文字之外，你就可以增加链接而不让文章的阅读感觉被打断。\r\n\r\n<h3 id=\"em\">强调</h3>\r\n\r\nMarkdown 使用星号（`*`）和底线（`_`）作为标记强调字词的符号，被 `*` 或 `_` 包围的字词会被转成用 `<em>` 标签包围，用两个 `*` 或 `_` 包起来的话，则会被转成 `<strong>`，例如：\r\n\r\n    *single asterisks*\r\n\r\n    _single underscores_\r\n\r\n    **double asterisks**\r\n\r\n    __double underscores__\r\n\r\n会转成：\r\n\r\n    <em>single asterisks</em>\r\n\r\n    <em>single underscores</em>\r\n\r\n    <strong>double asterisks</strong>\r\n\r\n    <strong>double underscores</strong>\r\n\r\n你可以随便用你喜欢的样式，唯一的限制是，你用什么符号开启标签，就要用什么符号结束。\r\n\r\n强调也可以直接插在文字中间：\r\n\r\n    un*frigging*believable\r\n\r\n但是**如果你的 `*` 和 `_` 两边都有空白的话，它们就只会被当成普通的符号**。\r\n\r\n如果要在文字前后直接插入普通的星号或底线，你可以用反斜线：\r\n\r\n    \\*this text is surrounded by literal asterisks\\*\r\n\r\n<h3 id=\"code\">代码</h3>\r\n\r\n如果要标记一小段行内代码，你可以用反引号把它包起来（`` ` ``），例如：\r\n\r\n    Use the `printf()` function.\r\n\r\n会产生：\r\n\r\n    <p>Use the <code>printf()</code> function.</p>\r\n\r\n如果要在代码区段内插入反引号，你可以用多个反引号来开启和结束代码区段：\r\n\r\n    ``There is a literal backtick (`) here.``\r\n\r\n这段语法会产生：\r\n\r\n    <p><code>There is a literal backtick (`) here.</code></p>\r\n\r\n代码区段的起始和结束端都可以放入一个空白，起始端后面一个，结束端前面一个，这样你就可以在区段的一开始就插入反引号：\r\n\r\n	A single backtick in a code span: `` ` ``\r\n	\r\n	A backtick-delimited string in a code span: `` `foo` ``\r\n\r\n会产生：\r\n\r\n	<p>A single backtick in a code span: <code>`</code></p>\r\n	\r\n	<p>A backtick-delimited string in a code span: <code>`foo`</code></p>\r\n\r\n在代码区段内，`&` 和方括号**都**会被自动地转成 HTML 实体，这使得插入 HTML 原始码变得很容易，Markdown 会把下面这段：\r\n\r\n    Please don\'t use any `<blink>` tags.\r\n\r\n转为：\r\n\r\n    <p>Please don\'t use any <code>&lt;blink&gt;</code> tags.</p>\r\n\r\n你也可以这样写：\r\n\r\n    `&#8212;` is the decimal-encoded equivalent of `&mdash;`.\r\n\r\n以产生：\r\n\r\n    <p><code>&amp;#8212;</code> is the decimal-encoded\r\n    equivalent of <code>&amp;mdash;</code>.</p>\r\n\r\n\r\n\r\n<h3 id=\"img\">图片</h3>\r\n\r\n很明显地，要在纯文字应用中设计一个「自然」的语法来插入图片是有一定难度的。\r\n\r\nMarkdown 使用一种和链接很相似的语法来标记图片，同样也允许两种样式： *行内式*和*参考式*。\r\n\r\n行内式的图片语法看起来像是：\r\n\r\n    ![Alt text](/path/to/img.jpg)\r\n\r\n    ![Alt text](/path/to/img.jpg \"Optional title\")\r\n\r\n详细叙述如下：\r\n\r\n*   一个惊叹号 `!`\r\n*   接着一个方括号，里面放上图片的替代文字\r\n*   接着一个普通括号，里面放上图片的网址，最后还可以用引号包住并加上\r\n    选择性的 \'title\' 文字。\r\n\r\n参考式的图片语法则长得像这样：\r\n\r\n    ![Alt text][id]\r\n\r\n「id」是图片参考的名称，图片参考的定义方式则和连结参考一样：\r\n\r\n    [id]: url/to/image  \"Optional title attribute\"\r\n\r\n到目前为止， Markdown 还没有办法指定图片的宽高，如果你需要的话，你可以使用普通的 `<img>` 标签。\r\n\r\n* * *\r\n\r\n<h2 id=\"misc\">其它</h2>\r\n\r\n<h3 id=\"autolink\">自动链接</h3>\r\n\r\nMarkdown 支持以比较简短的自动链接形式来处理网址和电子邮件信箱，只要是用方括号包起来， Markdown 就会自动把它转成链接。一般网址的链接文字就和链接地址一样，例如：\r\n\r\n    <http://example.com/>\r\n\r\nMarkdown 会转为：\r\n\r\n    <a href=\"http://example.com/\">http://example.com/</a>\r\n\r\n邮址的自动链接也很类似，只是 Markdown 会先做一个编码转换的过程，把文字字符转成 16 进位码的 HTML 实体，这样的格式可以糊弄一些不好的邮址收集机器人，例如：\r\n\r\n    <address@example.com>\r\n\r\nMarkdown 会转成：\r\n\r\n    <a href=\"&#x6D;&#x61;i&#x6C;&#x74;&#x6F;:&#x61;&#x64;&#x64;&#x72;&#x65;\r\n    &#115;&#115;&#64;&#101;&#120;&#x61;&#109;&#x70;&#x6C;e&#x2E;&#99;&#111;\r\n    &#109;\">&#x61;&#x64;&#x64;&#x72;&#x65;&#115;&#115;&#64;&#101;&#120;&#x61;\r\n    &#109;&#x70;&#x6C;e&#x2E;&#99;&#111;&#109;</a>\r\n\r\n在浏览器里面，这段字串（其实是 `<a href=\"mailto:address@example.com\">address@example.com</a>`）会变成一个可以点击的「address@example.com」链接。\r\n\r\n（这种作法虽然可以糊弄不少的机器人，但并不能全部挡下来，不过总比什么都不做好些。不管怎样，公开你的信箱终究会引来广告信件的。）\r\n\r\n<h3 id=\"backslash\">反斜杠</h3>\r\n\r\nMarkdown 可以利用反斜杠来插入一些在语法中有其它意义的符号，例如：如果你想要用星号加在文字旁边的方式来做出强调效果（但不用 `<em>` 标签），你可以在星号的前面加上反斜杠：\r\n\r\n    \\*literal asterisks\\*\r\n\r\nMarkdown 支持以下这些符号前面加上反斜杠来帮助插入普通的符号：\r\n\r\n    \\   反斜线\r\n    `   反引号\r\n    *   星号\r\n    _   底线\r\n    {}  花括号\r\n    []  方括号\r\n    ()  括弧\r\n    #   井字号\r\n    +   加号\r\n    -   减号\r\n    .   英文句点\r\n    !   惊叹号\r\n\r\n<h2 id=\"acknowledgement\">感谢</h2>\r\n\r\n感谢 [leafy7382][] 协助翻译，[hlb][]、[Randylien][] 帮忙润稿，[ethantw][] 的[汉字标准格式・CSS Reset][]， [WM][] 回报文字错误。\r\n\r\n[leafy7382]:https://twitter.com/#!/leafy7382\r\n[hlb]:http://iamhlb.com/\r\n[Randylien]:http://twitter.com/randylien\r\n[ethantw]:https://twitter.com/#!/ethantw\r\n[汉字标准格式・CSS Reset]:http://ethantw.net/projects/han/\r\n[WM]:http://kidwm.net/\r\n\r\n感谢 [fenprace][]，[addv][]。\r\n\r\n[fenprace]:https://github.com/fenprace\r\n[addv]:https://github.com/addv\r\n\r\n----------\r\n<h2 id=\"editor\">Markdown 免费编辑器</h2>\r\n\r\nWindows 平台\r\n\r\n* [MarkdownPad](http://markdownpad.com/)\r\n* [MarkPad](http://code52.org/DownmarkerWPF/)\r\n\r\nLinux 平台\r\n\r\n* [ReText](http://sourceforge.net/p/retext/home/ReText/)\r\n\r\nMac 平台\r\n\r\n* [Mou](http://mouapp.com/)\r\n\r\n在线编辑器\r\n\r\n* [Markable.in](http://markable.in/)\r\n* [Dillinger.io](http://dillinger.io/)\r\n\r\n浏览器插件\r\n\r\n* [MaDe](https://chrome.google.com/webstore/detail/oknndfeeopgpibecfjljjfanledpbkog) (Chrome)\r\n\r\n高级应用\r\n\r\n* [Sublime Text 2](http://www.sublimetext.com/2) + [MarkdownEditing](http://ttscoff.github.com/MarkdownEditing/) / [教程](http://lucifr.com/2012/07/12/markdownediting-for-sublime-text-2/)',13,4,4,1,'2016-10-16 14:50:22','2016-10-16 22:51:30'),(7,'使用 GDB 调试程序','GDB是UNIX下面的程序调试工具, 可以调试多种类型程序, 主要可以完成以下四个功能:\r\n\r\n1. 启动你的程序，可以按照你的自定义的要求随心所欲的运行程序。 \r\n2. 可让被调试的程序在指定的调置的断点处停住。（断点可以是条件表达式）\r\n3. 当程序被停住时，可以检查此时程序中所发生的事。\r\n4. 动态的改变程序的执行环境。\r\n\r\n# 简单的调试例子\r\n\r\n测试程序如下：\r\n\r\n    #include <stdio.h>\r\n    int func(int n)\r\n    {\r\n        int sum=0,i;\r\n        for(i=0; i<n; i++)\r\n        {\r\n            sum+=i;\r\n        }\r\n        return sum;\r\n    }\r\n    void main()\r\n    {\r\n        int i; long result = 0;\r\n        for(i=1; i<=100; i++)\r\n        {\r\n            result += i;\r\n        }\r\n        printf(“result[1-100] = %d \\n”, result );\r\n        printf(“result[1-250] = %d \\n”, func(250) );\r\n    }\r\n\r\n编译生成执行文件（要调试C/C++的程序，在编译时必须要把调试信息加到可执行文件中：-g 选项）：\r\n\r\n    gcc -g C++_GDB_test.cpp -o C++_GDB_test.o\r\n\r\n一个简单的调试过程如下：\r\n\r\n    $ gdb C++_GDB_test.o\r\n    GNU gdb (GDB) 7.10.1\r\n    ......\r\n    done.\r\n    (gdb) l                    ----> l(list), 列出源码\r\n    6	*/\r\n    7\r\n    8	#include <stdio.h>\r\n    9	int func(int n)\r\n    10	{\r\n    11	    int sum=0,i;\r\n    12	    for(i=0; i<n; i++)\r\n    13	    {\r\n    14	        sum+=i;\r\n    15	    }\r\n    (gdb)                      ----> 直接回车表示重复上一次命令\r\n    16	    return sum;\r\n    17	}\r\n    18	int main()\r\n    19	{\r\n    20	    int i; long result = 0;\r\n    21	    for(i=1; i<=100; i++)\r\n    22	    {\r\n    23	        result += i;\r\n    24	    }\r\n    25	    printf(\"result[1-100] = %ld\\n\", result );\r\n    (gdb)\r\n    26	    printf(\"result[1-250] = %d\\n\", func(250));\r\n    27	}\r\n    (gdb) br 20                 ----> 设置断点，在源程序 20 行处\r\n    Breakpoint 1 at 0x100000edf: file C++_GDB_test.cpp, line 20.\r\n    (gdb) br func               ----> 设置断点，在函数func()入口处\r\n    Breakpoint 2 at 0x100000e97: file C++_GDB_test.cpp, line 11.\r\n    (gdb) info br               ----> 查看断点信息\r\n    Num     Type           Disp Enb Address            What\r\n    1       breakpoint     keep y   0x0000000100000edf in main() at C++_GDB_test.cpp:20\r\n    2       breakpoint     keep y   0x0000000100000e97 in func(int) at C++_GDB_test.cpp:11\r\n    (gdb) r                     ----> r(run) 运行程序\r\n    Starting program: .../C++_Code/C++_GDB_test.o\r\n    Breakpoint 1, main () at C++_GDB_test.cpp:20  ----> 在断点处停住\r\n    20	    int i; long result = 0;\r\n    (gdb) n                     ----> n(next)单条语句执行\r\n    21	    for(i=1; i<=100; i++)\r\n    (gdb) n\r\n    23	        result += i;\r\n    (gdb) n\r\n    21	    for(i=1; i<=100; i++)\r\n    (gdb) c                     ----> c(continue)继续运行程序到下一个断点\r\n    Continuing.\r\n    result[1-100] = 5050        ----> 程序输出\r\n    \r\n    Breakpoint 2, func (n=250) at C++_GDB_test.cpp:11\r\n    11	    int sum=0,i;\r\n    (gdb) n\r\n    12	    for(i=0; i<n; i++)\r\n    (gdb) br 14 if i==50        ----> 设置条件断点\r\n    Breakpoint 3 at 0x100000eb1: file C++_GDB_test.cpp, line 14.\r\n    (gdb) c\r\n    Continuing.\r\n    \r\n    Breakpoint 3, func (n=250) at C++_GDB_test.cpp:14\r\n    14	        sum+=i;\r\n    (gdb) p i                   ----> p(print): 打印变量i的值\r\n    $1 = 50\r\n    (gdb) p sum                 ----> p: 打印变量sum的值\r\n    $2 = 1225\r\n    (gdb) bt                    ----> 查看函数堆栈\r\n    #0  func (n=250) at C++_GDB_test.cpp:14\r\n    #1  0x0000000100000f36 in main () at C++_GDB_test.cpp:26\r\n    (gdb) finish                ----> 退出函数\r\n    Run till exit from #0  func (n=250) at C++_GDB_test.cpp:14\r\n    0x0000000100000f36 in main () at C++_GDB_test.cpp:26\r\n    26	    printf(\"result[1-250] = %d\\n\", func(250));\r\n    Value returned is $6 = 31125\r\n    (gdb) c\r\n    Continuing.\r\n    result[1-250] = 31125\r\n    [Inferior 1 (process 8845) exited normally]   ----> 程序退出，调试结束 \r\n    (gdb) q \r\n\r\n# core dump 调试\r\n\r\n当程序异常退出时，操作系统把程序当前的内存状况存储在一个core文件中，该文件包含了程序运行时的内存，寄存器状态，堆栈指针，内存管理信息还有各种函数调用堆栈信息等。通过分析这个文件，我们可以定位到程序异常退出的时候对应的堆栈调用等信息，找出问题所在并进行及时解决。\r\n\r\n首先要确定当前会话的 ulimit –c，若为0，则不会产生对应的coredump，需要进行修改和设置，`ulimit –c [size]`（注意，这里的size如果太小，则可能不会产生对应的core文件）。\r\n\r\n```\r\nulimit  -c unlimited  (可以产生core dump 且不受大小限制)\r\n```\r\n\r\ncore文件默认的存储位置为当前进程的工作目录（一般就是可执行文件所在的目录）。当程序出现段错误（试图访问或者修改不属于自己的内存地址时）时，就会产生 core dump，方便我们进行调试。下面是一些常见的段错误：\r\n\r\n* 内存访问越界：由于使用错误的下标，导致数组访问越界。\r\n* 非法指针访问：比如写 nullptr\r\n* 栈溢出：使用了大的局部变量\r\n\r\n下面是个简单的例子：\r\n\r\n```c++\r\n#include <iostream>\r\nusing namespace std;\r\n\r\nvoid test(){\r\n    int *p = nullptr;\r\n    *p = 1;             // Segment Fault\r\n}\r\nint main() {\r\n    test();\r\n    return 0;\r\n}\r\n```\r\n\r\n然后编译运行程序，用 GDB 查看其产生的 Core Dump 文件：\r\n\r\n```bash\r\n$ g++ -g demo.cpp -o demo.o -std=c++11\r\n$ ulimit -c\r\n0\r\n$ ulimit -c unlimited\r\n$ ./demo.o\r\n[1]    15193 segmentation fault (core dumped)  ./demo.o\r\n$ ~ ls\r\ncore  demo.cpp  demo.o\r\n➜  ~ gdb demo.o core\r\nGNU gdb (Ubuntu 7.7.1-0ubuntu5~14.04.2) 7.7.1\r\nCopyright (C) 2014 Free Software Foundation, Inc.\r\n......\r\nCore was generated by \'./demo.o\'.\r\nProgram terminated with signal SIGSEGV, Segmentation fault.\r\n#0  0x00000000004006dd in test () at demo.cpp:6\r\n6	    *p = 1;\r\n(gdb) bt\r\n#0  0x00000000004006dd in test () at demo.cpp:6\r\n#1  0x00000000004006ee in main () at demo.cpp:9\r\n```\r\n\r\n# 调试参数\r\n\r\ngdb调试中需要用到的命令\r\n\r\n* file [filename]：装入想要调试的可执行文件\r\n* kill [filename]：终止正在调试的程序\r\n* break [file:]function：在(file文件的)function函数中设置一个断点\r\n* clear：删除一个断点，这个命令需要指定代码行或者函数名作为参数\r\n* run [arglist]：运行您的程序 (如果指定了arglist,则将arglist作为参数运行程序)\r\n* bt Backtrace：显示程序堆栈信息\r\n* `x`：查看内存\r\n* print expr：打印表达式的值\r\n* continue：继续运行您的程序 (在停止之后，比如在一个断点之后)\r\n* list：列出产生执行文件的源代码的一部分\r\n* next：单步执行 (在停止之后); 跳过函数调用（与step相对应，step会进入函数内部）\r\n* set：设置变量的值。例如：set nval=54 将把54保存到nval变量中；设置输入参数也可以通过这个命令(例如当三个入参分别为a、b、c的话，set args a b c)\r\n* watch：使你能监视一个变量的值而不管它何时被改变\r\n* finish：继续执行，直到当前函数返回\r\n* ignore：忽略某个断点制定的次数。例：ignore 4 23 忽略断点4的23次运行，在第24次的时候中断\r\n* info [name]：查看name信息\r\n* xbreak：在当前函数的退出的点上设置一个断点\r\n* whatis：显示变量的值和类型\r\n* ptype：显示变量的类型\r\n* shell：使你能不离开 gdb 就执行 UNIX shell 命令\r\n* help [name]：显示GDB命令的信息，或者显示如何使用GDB的总体信息\r\n* quit：退出gdb.\r\n  \r\n`命令行参数`\r\n\r\n有时候，我们需要调试的程序需要有命令行参数，可以通过下面两种方式设置调试的程序的命令行参数：\r\n\r\n* gdb命令行的 –args 参数\r\n* gdb环境中 set args命令。\r\n\r\n# 高级的用法\r\n\r\n比如为了搞清楚柔性数组的内存分布特征，我们可以用下面的程序来验证：\r\n\r\n    #include <stdlib.h>\r\n    #include <string.h>\r\n    \r\n    struct line {\r\n       int length;\r\n       char contents[0]; // C99：char contents[]; 没有指定数组长度\r\n    };\r\n    \r\n    int main(){\r\n        int this_length=10;\r\n        struct line *thisline = (struct line *)\r\n                         malloc (sizeof (struct line) + this_length);\r\n        thisline->length = this_length;\r\n        memset(thisline->contents, \'a\', this_length);\r\n        return 0;\r\n    }\r\n\r\n然后用下面的调试过程来理解柔性数组的内存分布：\r\n\r\n![][1]\r\n\r\n# 参考\r\n\r\n[使用gdb调试程序详解](http://www.vimer.cn/2009/11/使用gdb调试程序详解.html)  \r\n[GDB中应该知道的几个调试方法](http://coolshell.cn/articles/3643.html)  \r\n[Codesign gdb on Mac OS X Yosemite](http://andresabino.com/2015/04/14/codesign-gdb-on-mac-os-x-yosemite-10-10-2/)  \r\n[详解 coredump](http://blog.csdn.net/tenfyguo/article/details/8159176)  \r\n[C++编译器无法捕捉到的8种错误](http://blog.jobbole.com/15837/)  \r\n[What is a segmentation fault?](http://stackoverflow.com/questions/2346806/what-is-a-segmentation-fault)  \r\n\r\n[1]: http://7xrlu9.com1.z0.glb.clouddn.com/C++_GDB_Debug_1.png\r\n\r\n\r\n',8,0,1,1,'2016-10-16 15:12:15','2016-10-16 23:12:15'),(8,'并行运算课程','并行计算是相对于串行计算而言，比如一个矩阵相乘的例子，下面给出串行程序的代码\r\n\r\n    void matrixMultiplication(int a[][SIZE], int b[][SIZE])\r\n    {\r\n        int i,j,k;\r\n        for(i = 0; i < c_row; i++) \r\n        {\r\n            for(j = 0; j < c_col; j++) \r\n            {\r\n                for(k = 0; k < a_col; k++) \r\n                {\r\n                    c[i][j] += a[i][k] * b[k][j];\r\n                }\r\n            }\r\n        }\r\n    }\r\n\r\n在上面的程序中，程序编译运行之后以一个进程（注意区分进程和线程这两个概念）的方式是按照for循环迭代顺序执行。那怎么并行矩阵相乘的代码呢？这里需要使用高级语言级别的并行库，常见的并行库有opemp，pthread，MPI，CUDA等，这些并行库一般都支持C/C++，程序员可以直接调用并行库的函数而不需要实现底层的CPU多核调用。下面给出opemmp版本的矩阵相乘程序。\r\n\r\n    void matrixMultiplication(int a[][SIZE], int b[][SIZE])\r\n    {\r\n        int i,j,k;\r\n        #pragma omp parallel shared(a,b,c) private(i,j,k)  \r\n        {  \r\n             #pragma omp for schedule(dynamic)  \r\n             for(i = 0; i < c_row; i++) \r\n             {\r\n                for(j = 0; j < c_col; j++) \r\n                {\r\n                    for(k = 0; k < a_col; k++) \r\n                    {\r\n                        c[i][j] += a[i][k] * b[k][j];\r\n                    }\r\n                }\r\n            }\r\n        }\r\n    }\r\n\r\nopemmp在没有改动原本代码的基础上实现了矩阵相乘的并行化，实现的办法仅仅是添加了两条openmp编译制导语句，在程序运行到并行代码时，程序的主线程会启动多线程把任务分成n份（n=CPU核心数)，然后在多核心上同时计算，最后主线程得到结果。当然除了多线程，程序也可以启动多进程进行并行计算，关于多进程，Linux下的fork()想必很多人都有了解，而mpich是目前很流行的多进程消息传递库。并行化看起来很简单不是么，但是，要设计高效能解决复杂问题的并行程序可不那么容易。\r\n',42,2,6,4,'2016-10-17 06:18:55','2016-10-18 16:19:45'),(9,'test','测试',10,0,2,7,'2016-11-07 10:43:47','2016-11-07 18:43:47'),(10,'test1','1. * > # ***test1***``![](http://)\r\n\r\n| Column 1 | Column 2 | Column 3 |\r\n| -------- | -------- | -------- |\r\n| Text     | Text     | Text     |\r\n\r\n',6,0,2,7,'2016-11-07 10:54:13','2016-11-07 18:54:13'),(11,'新的话题','新的话题测试',15,0,15,1,'2016-11-08 02:39:50','2016-11-08 10:39:50'),(12,'支持 Latex 公式的插入','现在支持 Latex 公式。\r\n\r\n行内公式用 `\\(` 和 `\\)` 包裹，行间公式用 `\\[` 和 `\\]` 包裹。\r\n\r\n# 具体例子\r\n\r\nLet\'s first define a few variables that we will need to use:\r\n\r\n* L = total number of layers in the network\r\n* \\(s_l\\) = number of units (not counting bias unit) in layer l\r\n* K = number of output units/classes\r\n\r\nRecall that in neural networks, we may have many output nodes. We denote \\(h_{\\Theta}(x)_k\\) as being a hypothesis that results in the \\(k^{th}\\) output. Our cost function for neural networks is going to be a generalization of the one we used for logistic regression. Recall that the cost function for regularized logistic regression was\r\n\r\n\\[J(\\theta) = - \\frac{1}{m} \\sum_{i=1}^m [ y^{(i)}\\ \\log (h_\\theta (x^{(i)})) + (1 - y^{(i)})\\ \\log (1 - h_\\theta(x^{(i)}))] + \\frac{\\lambda}{2m}\\sum_{j=1}^n \\theta_j^2\\]\r\n\r\nFor neural networks, it is going to be slightly more complicated:\r\n\r\n\\[\\begin{gather*} J(\\Theta) = - \\frac{1}{m} \\sum_{i=1}^m \\sum_{k=1}^K \\left[y^{(i)}_k \\log ((h_\\Theta (x^{(i)}))_k) + (1 - y^{(i)}_k)\\log (1 - (h_\\Theta(x^{(i)}))_k)\\right] + \\frac{\\lambda}{2m}\\sum_{l=1}^{L-1} \\sum_{i=1}^{s_l} \\sum_{j=1}^{s_{l+1}} ( \\Theta_{j,i}^{(l)})^2\\end{gather*}\\]\r\n',15,2,15,1,'2017-01-09 14:20:51','2017-01-09 14:20:51');
/*!40000 ALTER TABLE `topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_questions`
--

DROP TABLE IF EXISTS `user_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_questions` (
  `user_id` int(11) NOT NULL,
  `classify_id` int(11) NOT NULL,
  `question_type` varchar(128) NOT NULL,
  `last_time` datetime NOT NULL,
  PRIMARY KEY (`user_id`,`classify_id`,`question_type`),
  KEY `user_id` (`user_id`),
  KEY `classify_id` (`classify_id`),
  CONSTRAINT `user_questions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `user_questions_ibfk_2` FOREIGN KEY (`classify_id`) REFERENCES `classifies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_questions`
--

LOCK TABLES `user_questions` WRITE;
/*!40000 ALTER TABLE `user_questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(128) NOT NULL,
  `password_hash` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `is_password_reset_link_valid` tinyint(1) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `date_joined` datetime DEFAULT NULL,
  `website` varchar(128) DEFAULT NULL,
  `avatar_url` varchar(128) DEFAULT NULL,
  `permissions` int(11) NOT NULL,
  `personal_id` varchar(64) DEFAULT NULL,
  `personal_profile` text,
  `telephone` varchar(64) DEFAULT NULL,
  `topicNum` int(11) NOT NULL,
  `postNum` int(11) NOT NULL,
  `commentNum` int(11) NOT NULL,
  `open_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_users_email` (`email`),
  UNIQUE KEY `ix_users_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'root','pbkdf2:sha1:1000$xBnOyGu0$2265b81c262f0438d80348748b24db1f66a65425','1291023320@qq.com',0,'2017-02-24 20:39:07','2016-09-29 03:14:30','http://selfboot.cn','1.png?t=1475844478.0',1,NULL,'知其然，知其所以然。知识广度是深度的副产品！',NULL,5,1,3,NULL),(2,'test','pbkdf2:sha1:1000$JZE0rscV$a7b07ad8602a608e76dc583142b1aaf2c378c55b','1@qq.com',0,'2017-01-04 14:13:35','2016-09-29 03:35:29',NULL,'none.jpg',1,NULL,'好好学习，天天向上',NULL,0,0,1,NULL),(3,'teacher','pbkdf2:sha1:1000$ZRqJzJuR$ec4e50db6eb3eaae92e7cb8bd9468fd2743c3505','teacher@qq.com',0,'2017-02-25 10:48:40','2016-09-29 03:36:08','http://a','3.png?t=1477293245.0',2,NULL,'混吃等死不舒服',NULL,0,3,5,NULL),(4,'abc','pbkdf2:sha1:1000$Z0hb47ZO$8cc84309e6a696c6deb28d6ebb910fa828d16e3d','3@qq.com',0,'2016-10-23 10:40:03','2016-10-17 03:00:38',NULL,'none.jpg',1,NULL,NULL,NULL,1,2,0,NULL),(5,'admin','pbkdf2:sha1:1000$h9IWWCJh$78e5c725ab15124732c7b19dbe43775df4e823e1','admin@qq.com',0,'2017-02-25 10:56:34','2016-10-22 11:41:15',NULL,'none.jpg',0,NULL,NULL,NULL,0,0,0,NULL),(6,'wudi','pbkdf2:sha1:1000$Qk7DY2fe$1a4a67c484525536c1abbe395bd8b5861d7ace37','wudi27@mail.sysu.edu.cn',0,'2016-10-18 11:13:55','2016-10-18 02:57:55',NULL,'none.jpg',1,NULL,NULL,NULL,1,1,0,NULL),(7,'yongyi_yang','pbkdf2:sha1:1000$qeUp02pL$088fe9b296a054b622d5b3826045d9c7dbd28e9c','18826073128@163.com',0,'2016-12-15 12:03:44','2016-10-18 15:03:29',NULL,'none.jpg',1,NULL,NULL,NULL,2,0,0,NULL),(8,'alexhanbing','pbkdf2:sha1:1000$MsiV0RcE$b9d0794fd92ce0f1d6c3432f4a68614ec60294ca','565613352@qq.com',0,'2016-10-21 14:18:52','2016-10-21 14:18:52',NULL,NULL,1,NULL,NULL,NULL,0,3,0,NULL),(9,'forest80','pbkdf2:sha1:1000$34jYf26A$3f6f628bd4e48ed8492219171920e9d498d5023b','forest80@163.com',1,'2016-12-05 14:04:15','2016-12-05 14:04:15',NULL,'none.jpg',1,NULL,NULL,NULL,0,0,0,NULL),(10,'Zouzhp','pbkdf2:sha1:1000$fzjFGAmb$30667cca608819c147c04d5a49671989dd66cefd','503951764@qq.com',1,'2017-01-10 09:47:07','2016-12-12 10:22:07',NULL,'10.png?t=1481509362.88',1,NULL,NULL,NULL,0,0,0,NULL),(11,'test1','pbkdf2:sha1:1000$3fdjJ0du$b93a90b23e1365bd53962cf7339ff69d7c6e0423','test@163.com',1,'2016-12-15 12:15:14','2016-12-15 12:15:14',NULL,'none.jpg',1,NULL,NULL,NULL,0,0,0,NULL),(12,'test_nscc','pbkdf2:sha1:1000$ANtf20qe$a3f467c203a80abde2b126307f04af5affb50164','lijianggs@126.com',1,'2017-01-09 15:32:27','2017-01-03 15:14:08',NULL,'none.jpg',1,NULL,NULL,NULL,0,0,0,NULL),(13,'111','pbkdf2:sha1:1000$DaD5XWyO$c00d0caab874bac4e3ef1328bdcfc0408a5974b9','1970025901@qq.com',1,'2017-01-14 23:46:19','2017-01-09 18:47:36',NULL,'none.jpg',1,NULL,NULL,NULL,0,0,0,NULL),(14,'233','pbkdf2:sha1:1000$OdRDanMv$0def1b35ce8cb669df1034d4a2c2bb1d057bbae6','50395@qq.com',1,'2017-01-14 21:42:28','2017-01-14 21:42:28',NULL,'none.jpg',1,NULL,NULL,NULL,0,0,0,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-02-25 10:59:49
