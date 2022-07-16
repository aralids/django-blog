FROM ghcr.io/railwayapp/nixpacks:debian-1657555817

WORKDIR /app/

# Setup
COPY environment.nix /app/
RUN nix-env -if environment.nix





# Load environment variables


# Install
COPY requirements.txt /app/
RUN  python -m venv /opt/venv && . /opt/venv/bin/activate && pip install -r requirements.txt

ENV PATH /opt/venv/bin:$PATH
RUN printf '\nPATH=/opt/venv/bin:$PATH' >> /root/.profile

# Build
COPY . /app/
RUN  python manage.py collectstatic --no-input

# Start
COPY . /app/
CMD python manage.py migrate && gunicorn techstructive_blog.wsgi
