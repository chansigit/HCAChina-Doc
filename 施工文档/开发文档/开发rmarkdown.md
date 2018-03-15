实现getMarkdownEN()

def getMarkdownEN(self,):
	mdtext = """
	### Bowtie2 Mapping Result
	The mapping rate is shown below:
	```{r}
	con <- file("{mapRs}", "r", blocking = FALSE)
	readLines(con)
	```
	Total map reads means that total number of reads mapped to genome
	
	""".format(mapRs = self.getOutput('mapRsOutput'))
	

在python内运行测试代码

>>>bt = Bowtie()
>>>session.run()
>>>bt2.getMarkdownEN()
The mapping rate is shown below:
```{r}
con <- file("/home/weizheng/zuoye/step_00_Bowtie2/mapRsOutput.txt", "r", blocking = FALSE)
readLines(con)
```
Total map reads means that total number of reads mapped to genome


将上述内容拷到rmarkdown文件里面
以下为XXX.Rmd文件内容

---
title: "test"
author: "wz"
date: "2018年3月14日"
output: html_document
---


The mapping rate is shown below:
```{r}
con <- file("/home/weizheng/zuoye/step_00_Bowtie2/mapRsOutput.txt", "r", blocking = FALSE)
readLines(con)
```
Total map reads means that total number of reads mapped to genome

进入R

>library(rmarkdown)
>render('XXX.Rmd')

结果会生成一个XXX.html

在浏览器里打开查看效果


