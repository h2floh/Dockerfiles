FROM python:3

# add your code and supplementary files
ADD my_script.py /

# install your dependency packages
RUN pip install pystrich

# start your executable
CMD [ "python", "./my_script.py" ]