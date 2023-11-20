import org.cloudbus.cloudsim.*;
import org.cloudbus.cloudsim.core.CloudSim;

import java.util.Calendar;
import java.util.LinkedList;
import java.util.List;

public class SimpleCloudSimExample {

    public static void main(String[] args) {
        CloudSim.init(1, Calendar.getInstance(), false);

        Datacenter datacenter = createDatacenter();
        Vm vm = createVm();
        Cloudlet cloudlet = createCloudlet(vm);

        datacenter.submitVmList(List.of(vm));
        datacenter.submitCloudletList(List.of(cloudlet));

        CloudSim.startSimulation();
        CloudSim.stopSimulation();

        List<Cloudlet> finishedCloudlets = CloudSim.getCloudletFinishedList();
        printCloudletList(finishedCloudlets);
    }

    private static Datacenter createDatacenter() {
        List<Host> hostList = List.of(new Host(0, new RamProvisionerSimple(2048), new BwProvisionerSimple(10000), 1000000, List.of(new Pe(0, new PeProvisionerSimple(1000))), new VmSchedulerSpaceShared(List.of(new Pe(0, new PeProvisionerSimple(1000)))))));
        DatacenterCharacteristics characteristics = new DatacenterCharacteristics("x86", "Linux", "Xen", hostList.get(0), 10.0, 3.0, 0.05, 0.1, 0.1);
        return new Datacenter("Datacenter_0", characteristics, new VmAllocationPolicySimple(hostList), new LinkedList<>(), 0);
    }

    private static Vm createVm() {
        return new Vm(0, 0, 1000, 1, 1024, 512, 10000, "Xen", new CloudletSchedulerSpaceShared());
    }

    private static Cloudlet createCloudlet(Vm vm) {
        UtilizationModel utilizationModel = new UtilizationModelFull();
        Cloudlet cloudlet = new Cloudlet(0, 1000, 1, 0, 0, utilizationModel, utilizationModel, utilizationModel);
        cloudlet.setUserId(0);
        cloudlet.setVmId(vm.getId());
        return cloudlet;
    }

    private static void printCloudletList(List<Cloudlet> list) {
        System.out.println("========== OUTPUT ==========");
        System.out.println("Cloudlet ID\tSTATUS\tData center ID\tVM ID\tTime\tStart Time\tFinish Time");

        for (Cloudlet cloudlet : list) {
            System.out.println(String.format("%-10d\t%-10s\t%-20d\t%-10d\t%-10d\t%-10f\t%-10f",
                    cloudlet.getCloudletId(),
                    Cloudlet.getStatusString(cloudlet.getStatus()),
                    cloudlet.getResourceId(),
                    cloudlet.getVmId(),
                    cloudlet.getActualCPUTime(),
                    cloudlet.getExecStartTime(),
                    cloudlet.getFinishTime()));
        }
    }
}
