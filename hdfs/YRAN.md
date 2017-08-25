README.md

> http://www.infoq.com/cn/articles/YarnOnDocker-forDCCluster?utm_campaign=rightbar_v2&utm_source=infoq&utm_medium=articles_link&utm_content=link_text

Hadoop配置优化

因为使用docker将原来一台机器一个nodemanager给细化为了多个，会造成nodemanager个数的成倍增加，因此hadoop的一些配置需要相应优化。

yarn.nodemanager.localizer.fetch.thread-count 随着容器数量增加，需要相应调整该参数
yarn.resourcemanager.amliveliness-monitor.interval-ms默认1秒，改为10秒，否则时间太短可能导致有些节点无法注册
yarn.resourcemanager.resource-tracker.client.thread-count默认50，改为100，随着容器数量增加，需要相应调整该参数
yarn.nodemanager.pmem-check-enabled默认true，改为false，不检查任务正在使用的物理内存量
容器中hadoop ulimit值修改，默认4096，改成655350