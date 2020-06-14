DRAFT:=software-trust-cycle
VERSION:=$(shell ./getver ${DRAFT}.mkd )
EXAMPLES=

${DRAFT}-${VERSION}.txt: ${DRAFT}.txt
	cp ${DRAFT}.txt ${DRAFT}-${VERSION}.txt

%.xml: %.mkd
	kramdown-rfc2629 ${DRAFT}.mkd >${DRAFT}.xml

%.txt: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc $? $@

%.html: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --html -o $@ $?

submit: ${DRAFT}.xml
	xml2rfc --v2v3 ${DRAFT}.xml
	curl -S -F "user=mcr+ietf@sandelman.ca" -F "xml=@${DRAFT}.v2v3.xml" https://datatracker.ietf.org/api/submit

version:
	echo Version: ${VERSION}

clean:
	-rm -f ${DRAFT}.xml

.PRECIOUS: ${DRAFT}.xml
