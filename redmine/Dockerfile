FROM redmine:3.4.2

USER redmine
WORKDIR /usr/src/redmine/
COPY redmine_config.ru /usr/src/redmine/config.ru

ENV R_WORKTIME_VERSION 0.3.4
ENV R_WORKTIME_MD5 3e10961af00fc905da5e9bb7960b13c1
RUN mkdir -p plugins/redmine_work_time && cd plugins/redmine_work_time \
	&& wget -O worktime.tar.gz "https://bitbucket.org/tkusukawa/redmine_work_time/get/${R_WORKTIME_VERSION}.tar.gz" \
	&& echo "$R_WORKTIME_MD5 worktime.tar.gz" | md5sum -c - \
	&& tar -xvf worktime.tar.gz --strip-components=1 \
	&& rm worktime.tar.gz

ENV R_CLIPBOARDIMAGEPASTE_VERSION v1.12
ENV R_CLIPBOARDIMAGEPASTE_MD5 a6a990587e330127966bc2df59d8094b
RUN mkdir -p plugins/clipboard_image_paste && cd plugins/clipboard_image_paste \
	&& wget -O clipboard_image_paste.tar.gz "https://github.com/peclik/clipboard_image_paste/archive/${R_CLIPBOARDIMAGEPASTE_VERSION}.tar.gz" \
	&& echo "$R_CLIPBOARDIMAGEPASTE_MD5 clipboard_image_paste.tar.gz" | md5sum -c - \
	&& tar -xvf clipboard_image_paste.tar.gz --strip-components=1 \
	&& rm clipboard_image_paste.tar.gz

# upstream is not exsisted version
ENV R_WIKIUNC_VERSION master
ENV R_WIKIUNC_MD5 61069054d1d3866e0c7afe06bf14747d
RUN mkdir -p plugins/redmine_wiki_unc && cd plugins/redmine_wiki_unc \
	&& wget -O redmine_wiki_unc.tar.gz "https://github.com/bearmini/redmine_wiki_unc/archive/${R_WIKIUNC_VERSION}.tar.gz" \
	&& echo "$R_WIKIUNC_MD5 redmine_wiki_unc.tar.gz" | md5sum -c - \
	&& tar -xvf redmine_wiki_unc.tar.gz --strip-components=1 \
	&& rm redmine_wiki_unc.tar.gz

ENV R_LDAPSYNC_VERSION 2.1.0
ENV R_LDAPSYNC_MD5 3854a49d766019ab76dffd7b51dbb149
RUN mkdir -p plugins/redmine_ldap_sync && cd plugins/redmine_ldap_sync \
	&& wget -O redmine_ldap_sync.tar.gz "https://github.com/thorin/redmine_ldap_sync/archive/${R_LDAPSYNC_VERSION}.tar.gz" \
	&& echo "$R_LDAPSYNC_MD5 redmine_ldap_sync.tar.gz" | md5sum -c - \
	&& tar -xvf redmine_ldap_sync.tar.gz --strip-components=1 \
	&& rm redmine_ldap_sync.tar.gz

ENV R_MESSENGER_VERSION 1.0.2
ENV R_MESSENGER_MD5 677ad226447ece9ea1957e7e2f41650e
RUN mkdir -p plugins/redmine_messenger && cd plugins/redmine_messenger \
	&& wget -O redmine_messenger.tar.gz "https://github.com/AlphaNodes/redmine_messenger/archive/${R_MESSENGER_VERSION}.tar.gz" \
	&& echo "$R_MESSENGER_MD5 redmine_messenger.tar.gz" | md5sum -c - \
	&& tar -xvf redmine_messenger.tar.gz --strip-components=1 \
	&& rm redmine_messenger.tar.gz

ENV R_GITHUBHOOK_VERSION v2.2.0
ENV R_GITHUBHOOK_MD5 8ee9683637fd053a3ff9861734f692cc
RUN mkdir -p plugins/redmine_messenger && cd plugins/redmine_messenger \
	&& wget -O github_hook.tar.gz "https://github.com/koppen/redmine_github_hook/archive/${R_GITHUBHOOK_VERSION}.tar.gz" \
	&& echo "$R_GITHUBHOOK_MD5 github_hook.tar.gz" | md5sum -c - \
	&& tar -xvf github_hook.tar.gz --strip-components=1 \
	&& rm github_hook.tar.gz


USER root

RUN bundle install --without development test && rake -T redmine:plugins:ldap_sync

