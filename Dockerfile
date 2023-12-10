# Use the OSRM backend image for the build stage
FROM osrm/osrm-backend as builder

# Set the work directory
WORKDIR /osrm-data

# Set environment variables
ENV OSM_PBF_FILE india-latest
ENV OSRM_DATA_PATH /osrm-data

# Download the OSM data file
ADD https://download.geofabrik.de/asia/india-latest.osm.pbf ${OSRM_DATA_PATH}/${OSM_PBF_FILE}.osm.pbf

# Run the OSRM processing commands
RUN osrm-extract -p /opt/car.lua ${OSRM_DATA_PATH}/${OSM_PBF_FILE}.osm.pbf && \
    osrm-partition ${OSRM_DATA_PATH}/${OSM_PBF_FILE}.osrm && \
    osrm-customize ${OSRM_DATA_PATH}/${OSM_PBF_FILE}.osrm

# Use the OSRM backend image for the final stage
FROM osrm/osrm-backend

# Copy the preprocessed data from the builder stage
COPY --from=builder /osrm-data /data

# Set the work directory
WORKDIR /data

# Create a non-root user and switch to it
RUN adduser -D myuser
USER myuser

# Expose the port used by OSRM
EXPOSE 5000

# Health check to ensure service is running
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# Command to start the OSRM server
CMD ["osrm-routed", "--algorithm", "mld", "/data/india-latest.osm.pbf"]
