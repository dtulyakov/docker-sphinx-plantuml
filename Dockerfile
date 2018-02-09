FROM python:3-alpine

COPY requirements.txt /requirements.txt

ENV LIBRARY_PATH=/lib:/usr/lib
#PlantUML
ENV PLANTUML_DIR /usr/local/plantuml
ENV PLANTUML_JAR plantuml.jar
ENV PLANTUML $PLANTUML_DIR/$PLANTUML_JAR

RUN set -x \
  && apk add -q --update --clean-protected --no-cache \
     openjdk8-jre \
     graphviz \
     jpeg-dev \
     zlib-dev \
     ttf-dejavu \
     freetype-dev \
     git \
  && apk --no-cache --virtual=dependencies add build-base python-dev py-pip wget \
    #PlantUML
  && mkdir $PLANTUML_DIR \
  && wget "https://sourceforge.net/projects/plantuml/files/plantuml.jar" --no-check-certificate \
  && mv plantuml.jar $PLANTUML_DIR \
    #TakaoFont for Japanese
  && wget "https://launchpad.net/takao-fonts/trunk/15.03/+download/TakaoFonts_00303.01.tar.xz" \
  && tar xvf TakaoFonts_00303.01.tar.xz -C /usr/share/fonts/ \
  && rm -f TakaoFonts_00303.01.tar.xz \
  && ln -s /usr/share/fonts/TakaoFonts_00303.01 /usr/share/fonts/TakaoFonts \
  #Upgrade pip
  && pip install --upgrade pip \
  && pip install -r /requirements.txt \
  && apk del dependencies \
  && rm /var/cache/apk/*

WORKDIR /sphinx

CMD ["/usr/local/bin/sphinx-build", "-b", "html", "/sphinx/source", "/sphinx/build"]
