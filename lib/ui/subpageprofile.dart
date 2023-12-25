import 'package:connection/models/profile.dart';
import 'package:connection/providers/diachimodel.dart';
import 'package:connection/providers/profileviewmodel.dart';
import 'package:connection/ui/page_dklop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/mainviewmodel.dart';
import 'AppConstant.dart';
import 'custom_control.dart';

class SubPageProfile extends StatelessWidget {
  const SubPageProfile({super.key});
  static int idpage = 1;

  Future <void> init(DiachiModel dcmodel, ProfileViewModel viewModel) async{
    Profile profile = Profile();
    if(dcmodel.listCity.isEmpty || 
      dcmodel.curCityId != profile.user.provinceid || 
      dcmodel.curDistId != profile.user.districtid || 
      dcmodel.curWardId != profile.user.wardid)
    {
      viewModel.displaySpinner();
      await dcmodel.initialize(
        profile.user.provinceid, 
        profile.user.districtid, 
        profile.user.wardid
      );
      print("--- finished --init ---");
      viewModel.hideSpinner();
    }
  }
  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<ProfileViewModel>(context);
    final dcmodel = Provider.of<DiachiModel>(context);
    final size = MediaQuery.of(context).size;
    final profile = Profile();
    Future.delayed(Duration.zero,()=>init(dcmodel, viewmodel));
    return GestureDetector(
        onTap: () => MainViewModel().closeMenu(),
        child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Column(
                  children: [
                    // -- start header -- //
                    createHeader(size, profile, viewmodel),
                    //end header ...
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomInputTextFormField(
                                title: 'Số điện thoại',
                                value: profile.user.phone,
                                width: size.width * 0.45,
                                callback: (output) {
                                  profile.user.phone = output;
                                  viewmodel.setModifiled();
                                  viewmodel.updatescreen();
                                },
                                type: TextInputType.phone,
                              ),
                              CustomInputTextFormField(
                                title: 'Ngày sinh',
                                value: profile.user.birthday,
                                width: size.width * 0.45,
                                callback: (output) {
                                  if (AppConstant.isDate(output)) {
                                    profile.user.birthday = output;
                                  }
                                  viewmodel.setModifiled();
                                  viewmodel.updatescreen();
                                },
                                type: TextInputType.datetime,
                              ),                              
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomPlaceDropDown(
                                  width: size.width * 0.45, 
                                  title: 'Thành phố/Tỉnh', 
                                  valueId: profile.user.provinceid, 
                                  valueName: profile.user.provincename,
                                  callback: ((outputID, outputName) async {
                                    viewmodel.displaySpinner();
                                    profile.user.provinceid = outputID;
                                    profile.user.provincename = outputName;
                                    await dcmodel.setCity(outputID);  
                                    profile.user.districtid = 0;
                                    profile.user.wardid = 0;
                                    profile.user.districtname = "";
                                    profile.user.wardname = "";
                                    viewmodel.setModifiled();
                                    viewmodel.hideSpinner();                              
                                  }), 
                                  list: dcmodel.listCity                                  
                                ),
                                CustomPlaceDropDown(
                                  width: size.width * 0.45, 
                                  title: 'Quận/Huyện', 
                                  valueId: profile.user.districtid, 
                                  valueName: profile.user.districtname,
                                  callback: ((outputID, outputName) async {
                                    viewmodel.displaySpinner();
                                    profile.user.districtid = outputID;
                                    profile.user.districtname = outputName;
                                    await dcmodel.setDistrict(outputID);  
                                    profile.user.wardid = 0;
                                    profile.user.wardname = "";
                                    viewmodel.setModifiled();
                                    viewmodel.hideSpinner();                              
                                  }), 
                                  list: dcmodel.listDistrict                                  
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomPlaceDropDown(
                                  width: size.width * 0.45, 
                                  title: 'Xã/Thị Trấn', 
                                  valueId: profile.user.wardid, 
                                  valueName: profile.user.wardname,
                                  callback: ((outputID, outputName) async {
                                    viewmodel.displaySpinner();
                                    profile.user.wardid = outputID;
                                    profile.user.wardname = outputName;
                                    await dcmodel.setWard(outputID);  
                                    viewmodel.setModifiled();
                                    viewmodel.hideSpinner();                              
                                  }), 
                                  list: dcmodel.listWard                                  
                              ),
                              CustomInputTextFormField(
                                title: 'Số nhà/Đường/Tổ Dân Phố',
                                value: profile.user.address,
                                width: size.width * 0.45,
                                callback: (output) {
                                  profile.user.address = output;
                                  viewmodel.setModifiled();
                                  viewmodel.updatescreen();
                                },
                                type: TextInputType.streetAddress,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                viewmodel.static == 1?CustomSpinner(size: size):Container(),
              ],
            )
          )
        );
  }

  Container createHeader(Size size, Profile profile, ProfileViewModel viewModel) {
    return Container(
      height: size.height * 0.25,
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppConstant.appbarcolor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  Text(
                    profile.student.diem.toString(),
                    style: AppConstant.textbodywhite,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomAvatar1(size: size),
              ),
            ],
          ),
          Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Tên : ', style: AppConstant.textbodywhite),
                  Text(profile.user.first_name,
                      style: AppConstant.textbodyfocuswhite),
                ],
              ),
              Row(
                children: [
                  Text('Mssv: ', style: AppConstant.textbodywhite),
                  Text(profile.student.mssv,
                      style: AppConstant.textbodywhitebold),
                ],
              ),
              Row(
                children: [
                  Text('Lop: ', style: AppConstant.textbodywhite),
                  Text(profile.student.tenlop,
                      style: AppConstant.textbodywhitebold),
                  profile.student.duyet == 0
                      ? Text(
                          "(chưa duyệt)",
                          style: AppConstant.textbodywhite,
                        )
                      : Text(''),
                ],
              ),
              Row(
                children: [
                  Text('Vai trò: ', style: AppConstant.textbodywhite),
                  profile.user.role_id == 4
                      ? Text('Sinh viên', style: AppConstant.textbodywhitebold)
                      : Text(
                          'Giảng viên',
                          style: AppConstant.textbodywhitebold,
                        ),
                ],
              ),
              SizedBox(
                width: size.width * 0.4,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: viewModel.modifile == 1 ? GestureDetector(
                    onTap: () {
                      viewModel.updateProfile();
                    },
                    child: Icon(Icons.save)): Container(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
