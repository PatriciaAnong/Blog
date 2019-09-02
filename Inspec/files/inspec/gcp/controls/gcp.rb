# copyright: 2019, Patricia Anong

title "PAnong Sample Control"

gcp_project_id = attribute("gcp_project_id")
region_name = attribute("region_name")
bucket = attribute("bucket")
zone = attribute("zone")
instance_name = attribute("instance_name", description: "GCP instance Name")

# you add controls/tests here
control "gcp-project-1.0" do
  impact 1.0
  title "Ensure project exists."
  describe google_project(project: gcp_project_id) do
    it { should exist }
    its("name") { should eq "InspecPlayGroundGCP" }
  end
end

control "gcp-single-region-0.1" do
  impact 0.1
  title "Ensure single region has the correct properties."
  desc "If us-east1-b is not available or present, re-assess deployment strategy."
  describe google_compute_region(project: gcp_project_id, name: region_name) do
    its("zone_names") { should include zone }
  end
end

control "gcp-regions-loop-0.3" do
  impact 0.3
  title "Ensure regions have the correct properties in bulk."
  desc "Verify the Regions available to the Project"
  google_compute_regions(project: gcp_project_id).region_names.each do |region_name|
    describe google_compute_region(project: gcp_project_id, name: region_name) do
      it { should be_up }
    end
  end
end

control "gcp-storage-bucket-0.5" do
  impact 0.5
  title "Ensure that the storage bucket was created"
  describe google_storage_bucket(name: bucket) do
    it { should exist }
    its("storage_class") { should eq "MULTI_REGIONAL" }
    its("location") { should eq "US" }
  end
end

control "gcp-instance-1.0" do
  impact 1.0
  title "Ensure the Instance was created and is running"
  desc "caveat", "If the Instance does not exist - run terraform apply."
  describe google_compute_instance(project: gcp_project_id, zone: zone, name: instance_name) do
    it { should exist }
    its("name") { should eq "panong-test-inspec-instance" }
    its("machine_type") { should match "n1-standard-1" }
    its("cpu_platform") { should match "Intel Haswell" }
    its("status") { should eq "RUNNING" }
  end
end