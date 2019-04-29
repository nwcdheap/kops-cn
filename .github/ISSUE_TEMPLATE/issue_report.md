---
name: issue or bug report
about: Create a report to help us improve

---

请注意，`kops-cn`没有侵入式修改上游`kops`源代码，并且保持跟上游`kops`版本一致，因此大部分`kops-cn`遇到的功能性问题都会存在上游`kops`专案当中，
在发布问题的时候请务必确定[查看并搜寻](https://github.com/kubernetes/kops/issues?utf8=%E2%9C%93&q=is%3Aissue+)了`kops`
上游是否有人发布过同样的的问题，这里无法解决`kops`本身存在的问题或issue，如果它是一个`kops`本身的issue，请务必发布到[上游kops专案的issue](https://github.com/kubernetes/kops/issues)当中。

如果你很肯定这个issue只跟`kops-cn`有关，跟上游`kops`无关，请填写以下信息方便我们进一步帮助您，并且尽可能提供截图给我们。

**1. What `kops` version are you running? The command `kops version`, will display
 this information.**

**2. What Kubernetes version are you running? `kubectl version` will print the
 version if a cluster is running or provide the Kubernetes version specified as
 a `kops` flag.**

**3. What AWS region are you using(Beijing or Ningxia)?**

**4. What commands did you run?  What is the simplest way to reproduce this issue?**

**5. What happened after the commands executed?**

**6. What did you expect to happen?**

**7. Please provide the content of your `Makefile` and how did you run the make command
  You may want to remove your cluster name and other sensitive information.**

**8. Anything else do we need to know?**
