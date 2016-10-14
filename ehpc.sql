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
INSERT INTO `alembic_version` VALUES ('00f8da978ac1');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(64) NOT NULL,
  `content` text NOT NULL,
  `visitNum` int(11) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
INSERT INTO `articles` VALUES (1,'并行运算比赛','这是一个比赛',43,'2016-09-12 00:00:00'),(2,'新的资讯','这是一饿新的资讯\n\n![](https://segmentfault.com/img/bVD8e5)',6,'2016-10-07 12:58:48'),(3,'测试',' 这是 Markdown 测试\r\n\r\n[测试](http://selfboot.cn)\r\n\r\n\r\n\r\n- 1\r\n- 2\r\n- 3',7,'2016-10-12 12:42:24'),(4,'新的文章','#测试提交\r\n\r\n## 标题1',20,'2016-10-12 12:45:43'),(5,'新的资讯信息','这是新的',0,'2016-10-14 08:35:46');
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `choice_classifies`
--

DROP TABLE IF EXISTS `choice_classifies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `choice_classifies` (
  `choice_id` int(11) DEFAULT NULL,
  `classify_id` int(11) DEFAULT NULL,
  KEY `choice_id` (`choice_id`),
  KEY `classify_id` (`classify_id`),
  CONSTRAINT `choice_classifies_ibfk_1` FOREIGN KEY (`choice_id`) REFERENCES `choices` (`id`),
  CONSTRAINT `choice_classifies_ibfk_2` FOREIGN KEY (`classify_id`) REFERENCES `classifies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `choice_classifies`
--

LOCK TABLES `choice_classifies` WRITE;
/*!40000 ALTER TABLE `choice_classifies` DISABLE KEYS */;
INSERT INTO `choice_classifies` VALUES (1,1),(1,2),(2,1),(2,2),(3,1),(4,1);
/*!40000 ALTER TABLE `choice_classifies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `choices`
--

DROP TABLE IF EXISTS `choices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `choices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(64) NOT NULL,
  `detail` text NOT NULL,
  `c_type` tinyint(1) NOT NULL,
  `answer` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `choices`
--

LOCK TABLES `choices` WRITE;
/*!40000 ALTER TABLE `choices` DISABLE KEYS */;
INSERT INTO `choices` VALUES (1,'题目 1','A选项;\nB选项;\nC选项;\nD选项; ',0,'A'),(2,'题目 2','A选项;\nB选项;\nC选项;\nD选项; ',0,'D'),(3,'题目 3','A选项;\nB选项;\nC选项;\nD选项; ',1,'A,B,C,D'),(4,'题目 4','A选项;\nB选项;\nC选项;\nD选项; ',1,'A');
/*!40000 ALTER TABLE `choices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classifies`
--

DROP TABLE IF EXISTS `classifies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classifies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classifies`
--

LOCK TABLES `classifies` WRITE;
/*!40000 ALTER TABLE `classifies` DISABLE KEYS */;
INSERT INTO `classifies` VALUES (1,'MPI'),(2,'并行计算'),(3,'超算特点');
/*!40000 ALTER TABLE `classifies` ENABLE KEYS */;
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
INSERT INTO `course_users` VALUES (1,1),(1,3),(1,2),(2,1);
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
  `title` varchar(64) DEFAULT NULL,
  `subtitle` varchar(64) DEFAULT NULL,
  `about` text,
  `createdTime` datetime DEFAULT NULL,
  `lessonNum` int(11) NOT NULL,
  `studentNum` int(11) DEFAULT NULL,
  `smallPicture` varchar(64) DEFAULT NULL,
  `middlePicture` varchar(64) DEFAULT NULL,
  `largePicture` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_courses_title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'课程1','这是课堂','首先，这个题目问的非常宽泛和庞大。如果要面面俱到的回答，并且解释清楚，恐怕需要专门开一系列的课程来学习。但是这并不妨碍我们去尝试分析这个题目，并且把关键的要点列出来，让大家明白其中核心的东西是什么。\r\n\r\n首先，我们把这个问题分成几个阶段：\r\n\r\n# “复杂”是什么？\r\n\r\n我们来看一些例子（图片来自于网络）：\r\n\r\n![](http://pic2.zhimg.com/70/7da97e11fc74cfbd81f00d59d471c2b5_b.jpg)\r\n\r\n![](http://pic2.zhimg.com/70/4fb20242a0ce2918373966bd9fae4489_b.jpg)\r\n\r\n我们可以看到许多“复杂”的例子，有建筑、有机械结构、有花纹、还有呃……垃圾堆。\r\n\r\n复杂是什么？这个问题当然很重要，虽然这个词看上去很普通——但我们必须要从专业的角度理解它，否则很难以专业的姿态去创造它。然而答案其实并不“复杂”：复杂就是观察对象的元素丰富度达到某一个程度，所形成的视觉心理感受。\r\n\r\n通过照片我们可以看到，上述这些对象中的“复杂”，实际上都是画面中（照片中）元素的复杂。这些元素很可能是由一些单体的模块（元单位，点线面，小元素等）排列组合而成的。它们在平面和空间中的相互排列、堆砌和组合，形成了相对密集的视觉效果。所谓的“复杂”，就是元素的“多”，是细节的“多”，是画面信息的“多”。\r\n\r\n但是很显然，并不是所有的复杂都会给我们带来美好的体验。我们看到的这些复杂的结果，有的好看，有的并不好看。看来只是了解什么是“复杂”并不够，我们还需要知道“好看”的复杂是因为什么。因为如果我们不能通过复杂这样一个表达手段去输出好看的结果，那么我们单纯了解这样一个概念、学习这样一个技巧和方法，可能并没有太大的价值，也就不能在满足要求的前提下输出审美，去为我们的作品增色。','2016-09-20 00:00:00',1,2,'images/course/1.jpg',NULL,NULL),(2,'课程2','第二个课程','这是的哥','2016-09-20 08:00:00',0,1,'images/course/2.jpg',NULL,NULL),(3,'课程3','这是课堂','内容','2016-09-21 00:00:00',1,3,'images/course/3.jpg',NULL,NULL),(4,'课程4','课程 4','内容','2016-09-22 00:00:00',1,2,'images/course/4.jpg',NULL,NULL),(5,'课程5','这是课堂','内容','2016-09-23 01:00:00',1,2,'images/course/5.jpg',NULL,NULL),(6,'课程6','这是课堂','内容','2016-09-29 01:00:00',0,1,'images/course/6.jpg',NULL,NULL),(7,'课程7','这是课堂7','内容','2016-09-29 08:00:00',0,1,'images/course/7.jpg',NULL,NULL),(8,'课程8','这是课堂8','内容','2016-09-29 10:00:00',0,1,'images/course/8.jpg',NULL,NULL);
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
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `group_members_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `users` (`id`),
  CONSTRAINT `group_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_members`
--

LOCK TABLES `group_members` WRITE;
/*!40000 ALTER TABLE `group_members` DISABLE KEYS */;
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
  `title` varchar(64) NOT NULL,
  `about` text NOT NULL,
  `logo` varchar(128) DEFAULT NULL,
  `memberNum` int(11) DEFAULT NULL,
  `topicNum` int(11) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (1,'群组1','第一个群组',NULL,12,12,'2016-09-20 00:00:00'),(2,'群组2','第二个群组',NULL,0,1,'2016-09-20 00:00:00'),(3,'群组3','第3个群组',NULL,12,1,'2016-09-20 00:00:00'),(4,'群组4','第4个群组',NULL,111,32,'2016-09-20 00:00:00'),(5,'群组5','第5个群组',NULL,1,2,NULL),(6,'群组6','第6个群组',NULL,111,32,'2016-09-20 00:00:00');
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
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
  `title` varchar(64) DEFAULT NULL,
  `content` text,
  `courseId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `courseId` (`courseId`),
  CONSTRAINT `lessons_ibfk_1` FOREIGN KEY (`courseId`) REFERENCES `courses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lessons`
--

LOCK TABLES `lessons` WRITE;
/*!40000 ALTER TABLE `lessons` DISABLE KEYS */;
INSERT INTO `lessons` VALUES (1,1,'课时1-1','测试',1),(2,2,'课时1-2','新的课程',1),(3,1,'开始1','NULL可好吃呢个',2),(4,3,'课时1-3','内容为空',1),(5,NULL,NULL,NULL,NULL);
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
  `name` varchar(64) NOT NULL,
  `uri` varchar(64) DEFAULT NULL,
  `lessonId` int(11) DEFAULT NULL,
  `m_type` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `lessonId` (`lessonId`),
  CONSTRAINT `materials_ibfk_1` FOREIGN KEY (`lessonId`) REFERENCES `lessons` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materials`
--

LOCK TABLES `materials` WRITE;
/*!40000 ALTER TABLE `materials` DISABLE KEYS */;
INSERT INTO `materials` VALUES (1,'视频资源测试','...',1,'video'),(2,'音频资源','12',1,'audio');
/*!40000 ALTER TABLE `materials` ENABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post`
--

LOCK TABLES `post` WRITE;
/*!40000 ALTER TABLE `post` DISABLE KEYS */;
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
  `title` varchar(64) NOT NULL,
  `detail` text NOT NULL,
  `difficulty` int(11) DEFAULT NULL,
  `acceptedNum` int(11) DEFAULT NULL,
  `submitNum` int(11) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs`
--

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;
INSERT INTO `programs` VALUES (1,'A+B','# 描述\n求两个整数A+B的和\n\n# 输入\n输入包含多组数据。  \n每组数据包含两个整数A(1 ≤ A ≤ 100)和B(1 ≤ B ≤ 100)。\n\n# 输出\n对于每组数据输出A+B的和。\n\n# 样例输入\n\n```\n1 2\n3 4\n```\n\n# 样例输出\n\n```\n3\n7\n```',1,12,23,'2016-10-24 00:00:00'),(2,'Trie树','# 描述\n\n小Hi和小Ho是一对好朋友，出生在信息化社会的他们对编程产生了莫大的兴趣，他们约定好互相帮助，在编程的学习道路上一同前进。\n\n这一天，他们遇到了一本词典，于是小Hi就向小Ho提出了那个经典的问题：“小Ho，你能不能对于每一个我给出的字符串，都在这个词典里面找到以这个字符串开头的所有单词呢？”\n\n身经百战的小Ho答道：“怎么会不能呢！你每给我一个字符串，我就依次遍历词典里的所有单词，检查你给我的字符串是不是这个单词的前缀不就是了？”\n\n小Hi笑道：“你啊，还是太年轻了！~假设这本词典里有10万个单词，我询问你一万次，你得要算到哪年哪月去？”\n\n小Ho低头算了一算，看着那一堆堆的0，顿时感觉自己这辈子都要花在上面了...\n\n小Hi看着小Ho的囧样，也是继续笑道：“让我来提高一下你的知识水平吧~你知道树这样一种数据结构么？”\n\n小Ho想了想，说道：“知道~它是一种基础的数据结构，就像这里说的一样！”\n\n小Hi满意的点了点头，说道：“那你知道我怎么样用一棵树来表示整个词典么？”\n\n小Ho摇摇头表示自己不清楚。\n\n[提示一：Trie树的建立](http://hihocoder.com/problemset/problem/1014#)\n\n“你看，我们现在得到了这样一棵树，那么你看，如果我给你一个字符串ap，你要怎么找到所有以ap开头的单词呢？”小Hi又开始考校小Ho。\n\n“唔...一个个遍历所有的单词？”小Ho还是不忘自己最开始提出来的算法。\n\n“笨！这棵树难道就白构建了！”小Hi教训完小Ho，继续道：“看好了！”\n\n[提示二：如何使用Trie树](http://hihocoder.com/problemset/problem/1014#)\n\n[提示三：在建立Trie树时同时进行统计！](http://hihocoder.com/problemset/problem/1014#)\n\n“那么现在！赶紧去用代码实现吧！”小Hi如是说道\n\n输入\n输入的第一行为一个正整数n，表示词典的大小，其后n行，每一行一个单词（不保证是英文单词，也有可能是火星文单词哦），单词由不超过10个的小写英文字母组成，可能存在相同的单词，此时应将其视作不同的单词。接下来的一行为一个正整数m，表示小Hi询问的次数，其后m行，每一行一个字符串，该字符串由不超过10个的小写英文字母组成，表示小Hi的一个询问。\n\n在20%的数据中n, m<=10，词典的字母表大小<=2.\n\n在60%的数据中n, m<=1000，词典的字母表大小<=5.\n\n在100%的数据中n, m<=100000，词典的字母表大小<=26.\n\n\n# 输出\n\n对于小Hi的每一个询问，输出一个整数Ans,表示词典中以小Hi给出的字符串为前缀的单词的个数。\n\n# 样例输入\n```\n5\nbabaab\nbabbbaaaa\nabba\naaaaabaa\nbabaababb\n5\nbabb\nbaabaaa\nbab\nbb\nbbabbaab\n```\n\n# 样例输出\n```\n1\n0\n3\n0\n0\n```',3,1,100,NULL);
/*!40000 ALTER TABLE `programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topics`
--

DROP TABLE IF EXISTS `topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(64) NOT NULL,
  `content` varchar(1024) NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topics`
--

LOCK TABLES `topics` WRITE;
/*!40000 ALTER TABLE `topics` DISABLE KEYS */;
INSERT INTO `topics` VALUES (1,'话题1','这是话题1',12,200,1,1,'2016-09-20 00:00:00',NULL),(2,'话题2','2',1,2,2,3,'2016-09-20 00:00:00',NULL),(3,'话题3','3',1,2,3,2,'2016-09-20 00:00:00',NULL),(4,'话题4','4',0,0,4,1,'2016-09-20 00:00:00',NULL);
/*!40000 ALTER TABLE `topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) DEFAULT NULL,
  `password_hash` varchar(128) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `is_password_reset_link_valid` tinyint(1) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `date_joined` datetime DEFAULT NULL,
  `website` varchar(64) DEFAULT NULL,
  `avatar_url` varchar(64) DEFAULT NULL,
  `permissions` int(11) NOT NULL,
  `personal_id` varchar(32) DEFAULT NULL,
  `personal_profile` text,
  `telephone` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_users_email` (`email`),
  UNIQUE KEY `ix_users_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'root','pbkdf2:sha1:1000$xBnOyGu0$2265b81c262f0438d80348748b24db1f66a65425','1291023320@qq.com',0,'2016-10-13 19:58:21','2016-09-29 03:14:30',NULL,'/static/upload/1.png?t=1475844478.0',0,NULL,NULL,NULL),(2,'test','pbkdf2:sha1:1000$JZE0rscV$a7b07ad8602a608e76dc583142b1aaf2c378c55b','1@qq.com',1,'2016-09-29 03:35:29','2016-09-29 03:35:29',NULL,'http://www.gravatar.com/avatar/',0,NULL,NULL,NULL),(3,'test2','pbkdf2:sha1:1000$9BWmBsyH$674d7552827b110e456b5ff7a9c2d1570dccb89f','2@qq.com',1,'2016-09-29 03:36:08','2016-09-29 03:36:08',NULL,'http://www.gravatar.com/avatar/',0,NULL,NULL,NULL);
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

-- Dump completed on 2016-10-14 17:06:04
